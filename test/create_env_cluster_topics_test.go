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
	confluentCloudAPIKey := os.Getenv("TERRATEST_CONFLUENT_CLOUD_SEED_KEY")
	confluentCloudAPISecret := os.Getenv("TERRATEST_CONFLUENT_CLOUD_SEED_SECRET")
	confluentCloudEmail := os.Getenv("TERRATEST_CONFLUENT_CLOUD_EMAIL")
	confluentCloudPassword := os.Getenv("TERRATEST_CONFLUENT_CLOUD_PASSWORD")
	GoogleCredentialsJSON := os.Getenv("TERRATEST_GOOGLE_CREDENTIALS_STORAGE")

	if confluentCloudAPIKey == "" || confluentCloudAPISecret == "" || confluentCloudEmail == "" || confluentCloudPassword == "" || GoogleCredentialsJSON == "" {
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
					"confluent_cloud_api_key":    confluentCloudAPIKey,
					"confluent_cloud_api_secret": confluentCloudAPISecret,
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
		kafkaTopicName1 := "squad_raw_service_example_1_entity"
		kafkaTopicName2 := "squad_raw_service_example_2_entity"
		kafkaClusterType := "BASIC"

		// Confluent Login, environment, and Kafka cluster setup
		os.Setenv("CONFLUENT_PLATFORM_PASSWORD", confluentCloudPassword)
		os.Setenv("CONFLUENT_PLATFORM_EMAIL", confluentCloudEmail)
		log.Printf("Setting Confluent environment: %s and cluster: %s...", envID, kafkaClusterID)
		runCLICommand(t, "confluent", "env", "use", envID)
		runCLICommand(t, "confluent", "kafka", "cluster", "use", kafkaClusterID)

		// Validate Total ACL Provision; Expecting a total of 10 ACLs:
		// - 4 ACLs are created by the connector service account module.
		// - 2 topics are being created, each generating 3 ACLs (read, write, and read from the connector).
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
		validateTerraformOutputWithCLI(t, envID, environmentName, kafkaClusterType, kafkaClusterID, kafkaClusterBasicName, bigQueryConnectorID, gcsSinkConnectorID, kafkaTopicName1, kafkaTopicName2, topicServiceAccountID)
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
func validateTerraformOutputWithCLI(t *testing.T, envID, environmentName, kafkaClusterType, kafkaClusterID, kafkaClusterBasicName, bigQueryConnectorID, gcsSinkConnectorID, kafkaTopicName1, kafkaTopicName2, topicServiceAccountID string) {
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
	a.Equal(kafkaClusterType, clusterDetails["type"], "Kafka Cluster type is not correct, it should be basic")
	a.Equal(kafkaClusterBasicName, clusterDetails["name"], "Kafka Cluster Name is not same")
	a.Equal("UP", clusterDetails["status"], "Kafka Cluster Status is not UP")
	log.Printf("Validated Kafka Cluster Type '%s', Name '%s', and Status 'UP' successfully.", kafkaClusterID, kafkaClusterBasicName)

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

	// Validate BigQuery Connector
	bigQueryConnectorOutput := runCLICommand(t, "confluent", "connect", "cluster", "describe", bigQueryConnectorID, "-o", "json")
	var bigQueryConnectorDetails map[string]interface{}
	a.NoError(json.Unmarshal([]byte(bigQueryConnectorOutput), &bigQueryConnectorDetails), "Failed to parse BigQuery Connector JSON output")
	a.Equal("RUNNING", bigQueryConnectorDetails["connector"].(map[string]interface{})["status"], "BigQuery Connector is not running")

	// BigQuery Connector class
	var actualBigQueryConnectorClass string
	for _, config := range bigQueryConnectorDetails["configs"].([]interface{}) {
		configMap := config.(map[string]interface{})
		if configMap["config"] == "connector.class" {
			actualBigQueryConnectorClass = configMap["value"].(string)
			break
		}
	}
	a.Equal("BigQuerySink", actualBigQueryConnectorClass, "BigQuery Connector class is not 'BigQuerySink'")

	// Validate GCS Sink Connector
	gcsConnectorOutput := runCLICommand(t, "confluent", "connect", "cluster", "describe", gcsSinkConnectorID, "-o", "json")
	var gcsConnectorDetails map[string]interface{}
	a.NoError(json.Unmarshal([]byte(gcsConnectorOutput), &gcsConnectorDetails), "Failed to parse GCS Connector JSON output")
	a.Equal("RUNNING", gcsConnectorDetails["connector"].(map[string]interface{})["status"], "GCS Connector is not running")

	// GCS Connector class
	var actualGCSConnectorClass string
	for _, config := range gcsConnectorDetails["configs"].([]interface{}) {
		configMap := config.(map[string]interface{})
		if configMap["config"] == "connector.class" {
			actualGCSConnectorClass = configMap["value"].(string)
		}
	}
	a.Equal("GcsSink", actualGCSConnectorClass, "GCS Connector class is not 'GcsSink'")
	log.Printf("Validated GCSSink Connector '%s' and BigQuery Connector '%s' successfully.", gcsSinkConnectorID, bigQueryConnectorID)

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

// Run a generic CLI command and return output
func runCLICommand(t *testing.T, command string, args ...string) string {
	cmd := exec.Command(command, args...)
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &out

	err := cmd.Run()
	assert.NoError(t, err, fmt.Sprintf("Command failed: %s %v. Output: %s", command, args, out.String()))

	return out.String()
}
