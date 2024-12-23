package test

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestEnvClusterTopic(t *testing.T) {
	runID := strings.ToLower(random.UniqueId())

	clusterName := "test-cluster-" + runID

	applyDestroyTestCaseName := "ApplyAndDestroy-" + clusterName

	workingDir := ""

	// Fetch environment variables
	cloudAPIKey := os.Getenv("TERRATEST_CONFLUENT_CLOUD_SEED_KEY")
	cloudAPISecret := os.Getenv("TERRATEST_CONFLUENT_CLOUD_SEED_SECRET")
	confluentCloudEmail := os.Getenv("TERRATEST_CONFLUENT_CLOUD_EMAIL")
	confluentCloudPassword := os.Getenv("TERRATEST_CONFLUENT_CLOUD_PASSWORD")
	GoogleCredentialsJSON := os.Getenv("TERRATEST_GOOGLE_CREDENTIALS_STORAGE")

	if cloudAPIKey == "" || cloudAPISecret == "" || confluentCloudEmail == "" || confluentCloudPassword == "" || GoogleCredentialsJSON == "" {
		t.Fatal("Required environment variables are not set")
	}

	t.Run(applyDestroyTestCaseName, func(t *testing.T) {
		workingDir = test_structure.CopyTerraformFolderToTemp(t, "..", "examples/create-env-cluster-topics")
		runOptions := &terraform.Options{}
		test_structure.RunTestStage(t, "create topics", func() {
			runOptions = terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: workingDir,
				EnvVars:      map[string]string{},
				Vars: map[string]interface{}{
					"environment":                runID,
					"confluent_cloud_api_key":    cloudAPIKey,
					"confluent_cloud_api_secret": cloudAPISecret,
					"google_credentials":         GoogleCredentialsJSON,
					"confluent_cloud_email":      confluentCloudEmail,
					"confluent_cloud_password":   confluentCloudPassword,
				},
			})
		})

		defer terraform.Destroy(t, runOptions)
		terraform.InitAndApply(t, runOptions)

		// Fetch Terraform outputs
		envID := terraform.Output(t, runOptions, "environment_id")
		environmentName := terraform.Output(t, runOptions, "environment_name")
		kafkaClusterID := terraform.Output(t, runOptions, "kafka_cluster_id")
		bigQueryConnectorID := terraform.Output(t, runOptions, "bigquery_connector_id")
		gcsSinkConnectorID := terraform.Output(t, runOptions, "connector_gcs_sink_connector_id")
		topicServiceAccountID := terraform.Output(t, runOptions, "topic_service_account_id")
		kafkaClusterBasicName := terraform.Output(t, runOptions, "kafka_cluster_basic_name")
		kafkaTopicName1 := terraform.Output(t, runOptions, "kafka_topic_name_1")
		kafkaTopicName2 := terraform.Output(t, runOptions, "kafka_topic_name_2")

		// Confluent Login, environment, and Kafka cluster setup
		os.Setenv("CONFLUENT_PLATFORM_PASSWORD", confluentCloudPassword)
		os.Setenv("CONFLUENT_PLATFORM_EMAIL", confluentCloudEmail)
		log.Printf("Setting Confluent environment: %s and cluster: %s...", envID, kafkaClusterID)
		runCLICommand(t, "confluent", "env", "use", envID)
		runCLICommand(t, "confluent", "kafka", "cluster", "use", kafkaClusterID)

		// Validate Total ACL Provision
		expectedTotalACLCount := 10
		ActualTotalACLCount := validateTotalKafkaACLCountWithCLI(t)
		assert.Equal(t, expectedTotalACLCount, ActualTotalACLCount, fmt.Sprintf(
			"Expected %d ACLs to be created, but found %d", expectedTotalACLCount, ActualTotalACLCount))

		// Validate individual ACL combinations count (ResourceType and Operation)
		individualExpectedACLs := []struct {
			ResourceType string
			Operation    string
			Count        int
		}{
			{"GROUP", "READ", 1},
			{"TOPIC", "CREATE", 1},
			{"TOPIC", "WRITE", 3},
			{"TOPIC", "READ", 4},
			{"CLUSTER", "DESCRIBE", 1},
		}
		validateIndividualKafkaACLDetails(t, individualExpectedACLs)

		// Validate Terraform outputs with confluent CLI
		validateTerraformOutputWithCLI(t, envID, environmentName, kafkaClusterID, kafkaClusterBasicName, bigQueryConnectorID, gcsSinkConnectorID, kafkaTopicName1, kafkaTopicName2, topicServiceAccountID)
	})
}

// Logic to Validate Total ACL Provision via Confluent CLI
func validateTotalKafkaACLCountWithCLI(t *testing.T) int {
	output := runCLICommand(t, "confluent", "kafka", "acl", "list", "-o", "json")
	log.Printf("Kafka ACL CLI Output: %s", output)

	var acls []map[string]interface{}
	err := json.Unmarshal([]byte(output), &acls)
	assert.NoError(t, err, "Failed to parse Kafka ACL JSON output")

	aclCount := len(acls)
	log.Printf("Actual ACL count: %d", aclCount)
	return aclCount
}

// Logic to validate individual ACL combinations (ResourceType and Operation) via Confluent CLI
func validateIndividualKafkaACLDetails(t *testing.T, expectedACLs []struct {
	ResourceType string
	Operation    string
	Count        int
}) {

	output := runCLICommand(t, "confluent", "kafka", "acl", "list", "-o", "json")
	var acls []map[string]interface{}
	err := json.Unmarshal([]byte(output), &acls)
	assert.NoError(t, err, "Failed to parse Kafka ACL JSON output")

	// Count ACLs by ResourceType and Operation
	actualCounts := make(map[string]int)
	for _, acl := range acls {
		key := fmt.Sprintf("%s|%s", acl["resource_type"], acl["operation"])
		actualCounts[key]++
	}

	// Validate actual counts against expected values
	for _, expected := range expectedACLs {
		key := fmt.Sprintf("%s|%s", expected.ResourceType, expected.Operation)
		actualCount := actualCounts[key]
		assert.Equal(t, expected.Count, actualCount, fmt.Sprintf(
			"Expected %d ACLs for ResourceType: %s, Operation: %s, but found %d",
			expected.Count, expected.ResourceType, expected.Operation, actualCount,
		))
	}

	log.Println("Individual ACL combination validation successful.")
}

// Logic to validate Terraform outputs with Confluent CLI
func validateTerraformOutputWithCLI(t *testing.T, envID, environmentName, kafkaClusterID, kafkaClusterBasicName, bigQueryConnectorID, gcsSinkConnectorID, kafkaTopicName1, kafkaTopicName2, topicServiceAccountID string) {
	a := assert.New(t)

	// Validate Environment ID and Name
	log.Println("Validating Environment ID and Name...")
	envOutput := runCLICommand(t, "confluent", "env", "describe", envID, "-o", "json")
	var envDetails map[string]interface{}
	a.NoError(json.Unmarshal([]byte(envOutput), &envDetails), "Failed to parse environment details")
	a.Equal(envID, envDetails["id"], "Environment ID mismatch")
	a.Equal(environmentName, envDetails["name"], "Environment Name mismatch")
	log.Printf("Validated Environment ID '%s' and Name '%s' successfully.", envID, environmentName)

	// Validate Kafka Cluster ID and Basic Name
	log.Println("Validating Kafka Cluster ID and Basic Name...")
	clusterOutput := runCLICommand(t, "confluent", "kafka", "cluster", "describe", kafkaClusterID, "-o", "json")
	var clusterDetails map[string]interface{}
	a.NoError(json.Unmarshal([]byte(clusterOutput), &clusterDetails), "Failed to parse Kafka Cluster details")
	a.Equal(kafkaClusterID, clusterDetails["id"], "Kafka Cluster ID mismatch")
	a.Equal(kafkaClusterBasicName, clusterDetails["name"], "Kafka Cluster Basic Name mismatch")
	a.Equal("UP", clusterDetails["status"], "Kafka Cluster Status mismatch")
	log.Printf("Validated Kafka Cluster ID '%s', Name '%s', and Status 'UP' successfully.", kafkaClusterID, kafkaClusterBasicName)

	// Validate Kafka Topic Names
	log.Println("Validating Kafka Topic Names...")
	topicOutput := runCLICommand(t, "confluent", "kafka", "topic", "list", "-o", "json")
	var topics []map[string]interface{}
	a.NoError(json.Unmarshal([]byte(topicOutput), &topics), "Failed to parse Kafka Topics JSON output")
	kafkaTopicNames := []string{kafkaTopicName1, kafkaTopicName2}

	// Validate each topic exists in the CLI output
	for _, expectedTopicName := range kafkaTopicNames {
		found := false
		for _, topic := range topics {
			if topic["name"] == expectedTopicName {
				found = true
				break
			}
		}
		a.True(found, fmt.Sprintf("Expected topic '%s' not found in Kafka Topics list", expectedTopicName))
		log.Printf("Validated Kafka Topic '%s' successfully.", expectedTopicName)
	}

	// Validate Sink Connector IDs
	log.Println("Validating Sink Connector IDs...")
	connectClustersOutput := runCLICommand(t, "confluent", "connect", "cluster", "list", "-o", "json")
	var connectClusters []map[string]interface{}
	a.NoError(json.Unmarshal([]byte(connectClustersOutput), &connectClusters), "Failed to parse Connect Clusters JSON output")

	gcsSinkFound := false
	bigQuerySinkFound := false

	for _, cluster := range connectClusters {
		if cluster["id"] == gcsSinkConnectorID {
			gcsSinkFound = true
		}
		if cluster["id"] == bigQueryConnectorID {
			bigQuerySinkFound = true
		}
		if gcsSinkFound && bigQuerySinkFound {
			break
		}
	}

	a.True(gcsSinkFound, fmt.Sprintf("GCS Sink Connector ID '%s' not found in Connect Clusters list", gcsSinkConnectorID))
	a.True(bigQuerySinkFound, fmt.Sprintf("BigQuery Connector ID '%s' not found in Connect Clusters list", bigQueryConnectorID))
	log.Printf("Validated Sink Connector IDs '%s' and '%s' successfully.", gcsSinkConnectorID, bigQueryConnectorID)

	// Validate Topic Service Account ID
	log.Println("Validating Topic Service Account ID...")
	serviceAccountsOutput := runCLICommand(t, "confluent", "iam", "service-account", "list", "-o", "json")
	var serviceAccounts []map[string]interface{}
	a.NoError(json.Unmarshal([]byte(serviceAccountsOutput), &serviceAccounts), "Failed to parse Service Accounts JSON output")

	serviceAccountFound := false
	for _, serviceAccount := range serviceAccounts {
		if serviceAccount["id"] == topicServiceAccountID {
			serviceAccountFound = true
			break
		}
	}
	assert.True(t, serviceAccountFound, fmt.Sprintf("Topic Service Account ID '%s' not found in service account list", topicServiceAccountID))
	log.Printf("Validated Topic Service Account ID '%s' successfully.", topicServiceAccountID)
}

// Run a generic Confluent CLI command and return output
func runCLICommand(t *testing.T, command string, args ...string) string {
	cmd := exec.Command(command, args...)
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &out

	err := cmd.Run()
	assert.NoError(t, err, fmt.Sprintf("Command failed: %s %v. Output: %s", command, args, out.String()))

	return out.String()
}
