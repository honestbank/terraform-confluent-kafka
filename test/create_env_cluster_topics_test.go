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
		a := assert.New(t)
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

		var output string

		output = terraform.Output(t, runOptions, "environment_name")
		a.True(strings.Contains(output, "labs-environment-"+runID))

		envID := terraform.Output(t, runOptions, "environment_id")
		clusterID := terraform.Output(t, runOptions, "kafka_cluster_id")

		output = terraform.Output(t, runOptions, "kafka_cluster_basic_name")
		a.True(strings.Contains(output, "labs-kafka-cluster-"))

		output = terraform.Output(t, runOptions, "topic_service_account_key")
		a.NotEmpty(output)

		output = terraform.Output(t, runOptions, "kafka_topic_name")
		a.Equal(output, "squad_raw_service_example_1_entity")

		output = terraform.Output(t, runOptions, "kafka_topic_name")
		a.Equal(output, "squad_raw_service_example_1_entity")

		output = terraform.Output(t, runOptions, "bigquery_connector_id")
		a.NotEmpty(output)

		output = terraform.Output(t, runOptions, "connector_gcs_sink_connector_id")
		a.NotEmpty(output)

		output = terraform.Output(t, runOptions, "kafka_acl_consumer_group_id")
		a.NotEmpty(output)

		// Confluent Login, environment, and Kafka cluster setup
		os.Setenv("CONFLUENT_PLATFORM_PASSWORD", confluentCloudPassword)
		os.Setenv("CONFLUENT_PLATFORM_EMAIL", confluentCloudEmail)
		log.Printf("Setting Confluent environment: %s and cluster: %s...", envID, clusterID)
		runCLICommand(t, "confluent", "env", "use", envID)
		runCLICommand(t, "confluent", "kafka", "cluster", "use", clusterID)

		// Validate Total ACL Provision
		expectedTotalACLCount := 11
		ActualTotalACLCount := validateTotalKafkaACLCountWithCLI(t)
		assert.Equal(t, expectedTotalACLCount, ActualTotalACLCount, fmt.Sprintf(
			"Expected %d ACLs to be created, but found %d", expectedTotalACLCount, ActualTotalACLCount))

		// Validate individual ACL combinations count (ResourceType and Operation)
		individualExpectedACLs := []struct {
			ResourceType string
			Operation    string
			Count        int
		}{
			{"GROUP", "READ", 2},
			{"TOPIC", "CREATE", 1},
			{"TOPIC", "WRITE", 3},
			{"TOPIC", "READ", 4},
			{"CLUSTER", "DESCRIBE", 1},
		}
		validateIndividualKafkaACLDetails(t, individualExpectedACLs)
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
