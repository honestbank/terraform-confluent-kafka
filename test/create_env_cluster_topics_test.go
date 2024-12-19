//package test
//
//import (
//	"fmt"
//	"os"
//	"strings"
//	"testing"
//
//	"github.com/gruntwork-io/terratest/modules/random"
//	"github.com/gruntwork-io/terratest/modules/terraform"
//	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
//	"github.com/stretchr/testify/assert"
//)
//
//func TestEnvClusterTopic(t *testing.T) {
//	runID := strings.ToLower(random.UniqueId())
//
//	clusterName := "test-cluster-" + runID
//
//	applyDestroyTestCaseName := "ApplyAndDestroy-" + clusterName
//
//	workingDir := ""
//
//	cloudAPIKey, exist := os.LookupEnv("TERRATEST_CONFLUENT_CLOUD_SEED_KEY")
//	if !exist {
//		fmt.Println("TERRATEST_CONFLUENT_CLOUD_SEED_KEY not set")
//		os.Exit(1)
//	}
//
//	cloudAPISecret, exist := os.LookupEnv("TERRATEST_CONFLUENT_CLOUD_SEED_SECRET")
//	if !exist {
//		fmt.Println("TERRATEST_CONFLUENT_CLOUD_SEED_SECRET not set")
//		os.Exit(1)
//	}
//	fmt.Printf("Got confluent credentials. Key/secret lengths %d/%d\n", len(cloudAPIKey), len(cloudAPISecret))
//
//	confluentCloudEmail, exist := os.LookupEnv("TERRATEST_CONFLUENT_CLOUD_EMAIL")
//	if !exist {
//		fmt.Println("TERRATEST_CONFLUENT_CLOUD_EMAIL not set")
//		os.Exit(1)
//	}
//
//	confluentCloudPassword, exist := os.LookupEnv("TERRATEST_CONFLUENT_CLOUD_PASSWORD")
//	if !exist {
//		fmt.Println("TERRATEST_CONFLUENT_CLOUD_PASSWORD not set")
//		os.Exit(1)
//	}
//	fmt.Printf("Got confluent cloud credential. Email/Password lengths %d/%d\n", len(confluentCloudEmail), len(confluentCloudPassword))
//
//	GoogleCredentialsJSON, exist := os.LookupEnv("TERRATEST_GOOGLE_CREDENTIALS_STORAGE")
//	if !exist {
//		fmt.Println("TERRATEST_GOOGLE_CREDENTIALS_STORAGE not set")
//		os.Exit(1)
//	}
//	fmt.Printf("Got Google Credentials. lengths %d\n", len(GoogleCredentialsJSON))
//
//	t.Run(applyDestroyTestCaseName, func(t *testing.T) {
//		a := assert.New(t)
//		workingDir = test_structure.CopyTerraformFolderToTemp(t, "..", "examples/create-env-cluster-topics")
//		runOptions := &terraform.Options{}
//		test_structure.RunTestStage(t, "create topics", func() {
//			runOptions = terraform.WithDefaultRetryableErrors(t, &terraform.Options{
//				TerraformDir: workingDir,
//				EnvVars:      map[string]string{},
//				Vars: map[string]interface{}{
//					"environment":                runID,
//					"confluent_cloud_api_key":    cloudAPIKey,
//					"confluent_cloud_api_secret": cloudAPISecret,
//					"google_credentials":         GoogleCredentialsJSON,
//					"confluent_cloud_email":      confluentCloudEmail,
//					"confluent_cloud_password":   confluentCloudPassword,
//				},
//			})
//		})
//
//		defer terraform.Destroy(t, runOptions)
//		terraform.InitAndApply(t, runOptions)
//
//		var output string
//
//		output = terraform.Output(t, runOptions, "environment_name")
//		a.True(strings.Contains(output, "labs-environment-"+runID))
//
//		output = terraform.Output(t, runOptions, "environment_id")
//		a.NotEmpty(output)
//
//		output = terraform.Output(t, runOptions, "kafka_cluster_basic_name")
//		a.True(strings.Contains(output, "labs-kafka-cluster-"))
//
//		output = terraform.Output(t, runOptions, "topic_service_account_key")
//		a.NotEmpty(output)
//
//		output = terraform.Output(t, runOptions, "kafka_topic_name")
//		a.Equal(output, "squad_raw_service_example_1_entity")
//
//		output = terraform.Output(t, runOptions, "kafka_topic_name")
//		a.Equal(output, "squad_raw_service_example_1_entity")
//
//		output = terraform.Output(t, runOptions, "bigquery_connector_id")
//		a.NotEmpty(output)
//
//		output = terraform.Output(t, runOptions, "connector_gcs_sink_connector_id")
//		a.NotEmpty(output)
//
//		output = terraform.Output(t, runOptions, "kafka_acl_consumer_group_id")
//		a.NotEmpty(output)
//	})
//}

package test

import (
	"bytes"
	"fmt"
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
		workingDir := test_structure.CopyTerraformFolderToTemp(t, "..", "examples/create-env-cluster-topics")

		// Set up Terraform options
		runOptions := &terraform.Options{
			TerraformDir: workingDir,
			Vars: map[string]interface{}{
				"environment":                runID,
				"confluent_cloud_api_key":    cloudAPIKey,
				"confluent_cloud_api_secret": cloudAPISecret,
				"confluent_cloud_email":      confluentCloudEmail,
				"confluent_cloud_password":   confluentCloudPassword,
				"google_credentials":         GoogleCredentialsJSON,
			},
		}

		defer terraform.Destroy(t, runOptions) // Cleanup resources
		terraform.InitAndApply(t, runOptions)  // Apply Terraform configuration

		// Fetch and assert Terraform outputs
		var output string

		output = terraform.Output(t, runOptions, "environment_name")
		a.True(strings.Contains(output, "labs-environment-"+runID), "Environment name is incorrect")

		output = terraform.Output(t, runOptions, "environment_id")
		a.NotEmpty(output, "Environment ID should not be empty")

		output = terraform.Output(t, runOptions, "kafka_cluster_basic_name")
		a.True(strings.Contains(output, "labs-kafka-cluster-"), "Kafka cluster name is incorrect")

		output = terraform.Output(t, runOptions, "topic_service_account_key")
		a.NotEmpty(output, "Topic service account key should not be empty")

		output = terraform.Output(t, runOptions, "kafka_topic_name")
		a.Equal(output, "squad_raw_service_example_1_entity", "Kafka topic name is incorrect")

		output = terraform.Output(t, runOptions, "bigquery_connector_id")
		a.NotEmpty(output, "BigQuery connector ID should not be empty")

		output = terraform.Output(t, runOptions, "connector_gcs_sink_connector_id")
		a.NotEmpty(output, "GCS Sink Connector ID should not be empty")

		//kafkaACLID := terraform.Output(t, runOptions, "kafka_acl_consumer_group_id")
		envID := terraform.Output(t, runOptions, "environment_id")
		clusterID := terraform.Output(t, runOptions, "kafka_cluster_id")

		// Step 1: Login, set environment, and Kafka cluster
		setupConfluentCLI(t, confluentCloudEmail, confluentCloudPassword, envID, clusterID)

		// Step 2: Validate ACL count
		expectedACLCount := 5 // Replace with your expected count
		actualACLCount := validateKafkaACLCountWithCLI(t)
		assert.Equal(t, expectedACLCount, actualACLCount, fmt.Sprintf(
			"Expected %d ACLs to be created, but found %d", expectedACLCount, actualACLCount))

		// Step 3: Validate individual ACLs
		expectedACLs := []struct {
			ResourceType string
			ResourceName string
			Operation    string
		}{
			{"GROUP", "squad_raw-", "READ"},
			{"TOPIC", "squad_raw_service_example_1_entity", "WRITE"},
			{"CLUSTER", "kafka-cluster", "DESCRIBE"},
		}
		validateKafkaACLDetails(t, expectedACLs)
	})
}

// Combined function for CLI login and setup
func setupConfluentCLI(t *testing.T, email, password, envID, clusterID string) {
	// Login to Confluent CLI
	runCLICommand(t, "confluent", "login", "--username", email, "--password", password)
	fmt.Println("Confluent CLI logged in successfully")

	// Set environment
	runCLICommand(t, "confluent", "env", "use", envID)
	fmt.Printf("Confluent environment set to %s\n", envID)

	// Set Kafka cluster
	runCLICommand(t, "confluent", "kafka", "cluster", "use", clusterID)
	fmt.Printf("Confluent Kafka cluster set to %s\n", clusterID)
}

// Validate ACL count using Confluent CLI
func validateKafkaACLCountWithCLI(t *testing.T) int {
	output := runCLICommand(t, "confluent", "kafka", "acl", "list")
	fmt.Printf("Kafka ACL CLI Output:\n%s\n", output)

	// Parse ACL count
	lines := strings.Split(output, "\n")
	aclCount := 0
	for _, line := range lines {
		if strings.Contains(line, "ResourceType:") { // Filter only valid ACL lines
			aclCount++
		}
	}
	fmt.Printf("Actual ACL count: %d\n", aclCount)
	return aclCount
}

// Validate individual ACL details
func validateKafkaACLDetails(t *testing.T, expectedACLs []struct {
	ResourceType string
	ResourceName string
	Operation    string
}) {
	output := runCLICommand(t, "confluent", "kafka", "acl", "list")
	fmt.Printf("Kafka ACL CLI Output:\n%s\n", output)

	for _, acl := range expectedACLs {
		aclDetails := fmt.Sprintf("ResourceType: %s, Name: %s, Operation: %s",
			acl.ResourceType, acl.ResourceName, acl.Operation)
		assert.True(t, strings.Contains(output, aclDetails), fmt.Sprintf(
			"Expected ACL '%s' not found in ACL list", aclDetails))
	}
	fmt.Println("All ACL validations successful")
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
