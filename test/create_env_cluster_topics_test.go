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

	environmentName := "labs-environment-" + runID
	kafkaClusterName := "labs-kafka-cluster-" + runID
	adminServiceAccountName := "labs-cluster-admin-sa-" + runID
	topicServiceAccountName := "labs-topic-sa-" + runID
	connectorServiceAccountName := "labs-cluster-connector-sa-" + runID
	bigQueryConnectorName := "labs-confluent-bigquery-sink-" + runID
	gcsConnectorName := "labs-confluent-gcs-sink-" + runID
	kafkaTopicName1 := "squad_raw_service_example_1_entity"
	kafkaTopicName2 := "squad_raw_service_example_2_entity"

	applyDestroyTestCaseName := "ApplyAndDestroy-" + environmentName

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
					"confluent_cloud_api_key":        confluentCloudAPIKey,
					"confluent_cloud_api_secret":     confluentCloudAPISecret,
					"google_credentials":             GoogleCredentialsJSON,
					"confluent_cloud_email":          confluentCloudEmail,
					"confluent_cloud_password":       confluentCloudPassword,
					"environment_name":               environmentName,
					"kafka_cluster_name":             kafkaClusterName,
					"admin_service_account_name":     adminServiceAccountName,
					"connector_service_account_name": connectorServiceAccountName,
					"service_account_name":           topicServiceAccountName,
					"topic_name_1":                   kafkaTopicName1,
					"topic_name_2":                   kafkaTopicName2,
					"bigquery_connector_name":        bigQueryConnectorName,
					"gcs_connector_name":             gcsConnectorName,
				},
			})
		})

		defer terraform.Destroy(t, runOptions)
		terraform.InitAndApply(t, runOptions)

		a := assert.New(t)

		// Fetch Terraform outputs
		envID := terraform.Output(t, runOptions, "environment_id")
		kafkaClusterID := terraform.Output(t, runOptions, "kafka_cluster_id")
		bigQueryConnectorID := terraform.Output(t, runOptions, "bigquery_connector_id")
		gcsSinkConnectorID := terraform.Output(t, runOptions, "connector_gcs_sink_connector_id")
		topicServiceAccountID := terraform.Output(t, runOptions, "topic_service_account_id")
		connectorServiceAccountID := terraform.Output(t, runOptions, "connector_service_account_id")

		// Confluent Login, environment, and Kafka cluster setup
		os.Setenv("CONFLUENT_PLATFORM_PASSWORD", confluentCloudPassword)
		os.Setenv("CONFLUENT_PLATFORM_EMAIL", confluentCloudEmail)
		log.Printf("Setting Confluent environment: %s and cluster: %s...", envID, kafkaClusterID)
		runCLICommand(t, "confluent", "env", "use", envID)
		runCLICommand(t, "confluent", "kafka", "cluster", "use", kafkaClusterID)

		// Validate Environment name with the environmentName input value
		log.Println("Validating environment name...")
		envOutput := runCLICommand(t, "confluent", "env", "describe", envID, "-o", "json")
		var envDetails map[string]interface{}
		a.NoError(json.Unmarshal([]byte(envOutput), &envDetails), "Failed to parse environment details")
		a.Equal(environmentName, envDetails["name"], "Environment name is not correct.")
		log.Printf("Validated environment name '%s' successfully.", environmentName)

		// Validate Kafka Cluster Name
		log.Println("Validating kafka cluster name, status and type...")
		clusterOutput := runCLICommand(t, "confluent", "kafka", "cluster", "describe", kafkaClusterID, "-o", "json")
		var clusterDetails map[string]interface{}
		a.NoError(json.Unmarshal([]byte(clusterOutput), &clusterDetails), "Failed to parse Kafka cluster details.")
		a.Equal("BASIC", clusterDetails["type"], "Kafka cluster type is not correct, it should be basic.")
		a.Equal(kafkaClusterName, clusterDetails["name"], "Kafka cluster name is not same.")
		a.Equal("UP", clusterDetails["status"], "Kafka cluster status is not UP.")
		log.Printf("Validated kafka cluster type 'basic', name '%s', and status 'UP' successfully.", kafkaClusterName)

		// Validate Kafka Topic Names
		log.Println("validating kafka topic names...")
		topicOutput := runCLICommand(t, "confluent", "kafka", "topic", "list", "-o", "json")
		var topics []map[string]interface{}
		a.NoError(json.Unmarshal([]byte(topicOutput), &topics), "Failed to parse kafka topics output")
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
			a.True(found, fmt.Sprintf("expected topic '%s' not found in kafka topics list", expectedTopicName))
			log.Printf("Validated kafka topic '%s' successfully.", expectedTopicName)
		}

		// Validate BigQuery Connector
		bigQueryConnectorOutput := runCLICommand(t, "confluent", "connect", "cluster", "describe", bigQueryConnectorID, "-o", "json")
		var bigQueryConnectorDetails map[string]interface{}
		a.NoError(json.Unmarshal([]byte(bigQueryConnectorOutput), &bigQueryConnectorDetails), "Failed to parse bigQuery connector output.")
		a.Equal("RUNNING", bigQueryConnectorDetails["connector"].(map[string]interface{})["status"], "bigQuery connector is not running.")
		a.Equal(bigQueryConnectorName, bigQueryConnectorDetails["connector"].(map[string]interface{})["name"], "bigQuery connector name is not correct.")

		// BigQuery Connector class
		var actualBigQueryConnectorClass string
		for _, config := range bigQueryConnectorDetails["configs"].([]interface{}) {
			configMap := config.(map[string]interface{})
			if configMap["config"] == "connector.class" {
				actualBigQueryConnectorClass = configMap["value"].(string)
				break
			}
		}
		a.Equal("BigQuerySink", actualBigQueryConnectorClass, "BigQuery connector class is not 'BigQuerySink'.")

		// Validate GCS Sink Connector
		gcsConnectorOutput := runCLICommand(t, "confluent", "connect", "cluster", "describe", gcsSinkConnectorID, "-o", "json")
		var gcsConnectorDetails map[string]interface{}
		a.NoError(json.Unmarshal([]byte(gcsConnectorOutput), &gcsConnectorDetails), "Failed to parse GCS connector output")
		a.Equal("RUNNING", gcsConnectorDetails["connector"].(map[string]interface{})["status"], "GCS connector is not running.")
		a.Equal(gcsConnectorName, gcsConnectorDetails["connector"].(map[string]interface{})["name"], "GCS connector name in not correct.")

		// GCS Connector class
		var actualGCSConnectorClass string
		for _, config := range gcsConnectorDetails["configs"].([]interface{}) {
			configMap := config.(map[string]interface{})
			if configMap["config"] == "connector.class" {
				actualGCSConnectorClass = configMap["value"].(string)
			}
		}
		a.Equal("GcsSink", actualGCSConnectorClass, "GCS Connector class is not 'GcsSink'")
		log.Printf("Validated GCSsink connector '%s' and BigQuery connector '%s' successfully.", gcsSinkConnectorID, bigQueryConnectorID)

		// Validate Topic Service Account name
		log.Println("Validating service account name...")
		serviceAccountsOutput := runCLICommand(t, "confluent", "iam", "service-account", "list", "-o", "json")
		var serviceAccounts []map[string]interface{}
		a.NoError(json.Unmarshal([]byte(serviceAccountsOutput), &serviceAccounts), "Failed to parse service accounts output")

		for _, account := range serviceAccounts {
			if account["name"] == adminServiceAccountName {
				a.Equal(adminServiceAccountName, account["name"], "Admin service account name is not crrect.")
				log.Printf("Admin service account '%s' validated successfully.", adminServiceAccountName)
			} else if account["name"] == topicServiceAccountName {
				a.Equal(topicServiceAccountName, account["name"], "Topic service account name is not crrect.")
				log.Printf("Topic Service Account '%s' validated successfully.", topicServiceAccountName)
			} else if account["name"] == connectorServiceAccountName {
				a.Equal(connectorServiceAccountName, account["name"], "Connector service sccount name is not correct.")
				log.Printf("Connector service account '%s' validated successfully.", connectorServiceAccountName)
			}
		}

		log.Printf("All three service account names are correct.")

		// Validate Total ACL Provision; Expecting a total of 10 ACLs:
		// - 4 ACLs are created by the connector service account module.
		// - 2 topics are being created, each generating 3 ACLs (read, write, and read from the connector).
		expectedTotalACLCount := 10
		ActualTotalACLCount := validateTotalKafkaACLCount(t)
		assert.Equal(t, expectedTotalACLCount, ActualTotalACLCount, fmt.Sprintf(
			"Expected %d ACLs to be created, but found %d", expectedTotalACLCount, ActualTotalACLCount))

		// validateKafkaACL validates the Kafka ACL data for the specified topic and connector service accounts.
		validateKafkaACL(t, topicServiceAccountID, connectorServiceAccountID)

	})
}

// Logic to Validate Total ACL Provision via Confluent CLI
func validateTotalKafkaACLCount(t *testing.T) int {
	output := runCLICommand(t, "confluent", "kafka", "acl", "list", "-o", "json")
	log.Printf("Kafka ACL array : %s", output)

	a := assert.New(t)

	var acls []map[string]interface{}
	err := json.Unmarshal([]byte(output), &acls)
	a.NoError(err, "Failed to parse kafka ACL output")

	aclCount := len(acls)
	log.Printf("Actual ACL count: %d", aclCount)
	return aclCount
}

// logic to validate the ACL data,It compares the actual ACL data obtained from the Kafka CLI against the expected ACL data
// for both the topic and connector service accounts. If the data matches, the validation is successful.
func validateKafkaACL(t *testing.T, topicServiceAccountID, connectorServiceAccountID string) {
	a := assert.New(t)

	expectedConnectorACLData := []map[string]interface{}{
		{"principal": "User:" + connectorServiceAccountID, "permission": "ALLOW", "operation": "CREATE", "resource_type": "TOPIC", "resource_name": "dlq-lcc", "pattern_type": "PREFIXED"},
		{"principal": "User:" + connectorServiceAccountID, "permission": "ALLOW", "operation": "DESCRIBE", "resource_type": "CLUSTER", "resource_name": "kafka-cluster", "pattern_type": "LITERAL"},
		{"principal": "User:" + connectorServiceAccountID, "permission": "ALLOW", "operation": "READ", "resource_type": "GROUP", "resource_name": "connect-lcc", "pattern_type": "PREFIXED"},
		{"principal": "User:" + connectorServiceAccountID, "permission": "ALLOW", "operation": "READ", "resource_type": "TOPIC", "resource_name": "squad_raw_service_example_1_entity", "pattern_type": "LITERAL"},
		{"principal": "User:" + connectorServiceAccountID, "permission": "ALLOW", "operation": "READ", "resource_type": "TOPIC", "resource_name": "squad_raw_service_example_2_entity", "pattern_type": "LITERAL"},
		{"principal": "User:" + connectorServiceAccountID, "permission": "ALLOW", "operation": "WRITE", "resource_type": "TOPIC", "resource_name": "dlq-lcc", "pattern_type": "PREFIXED"},
	}

	expectedTopicACLData := []map[string]interface{}{
		{"principal": "User:" + topicServiceAccountID, "permission": "ALLOW", "operation": "READ", "resource_type": "TOPIC", "resource_name": "squad_raw_service_example_1_entity", "pattern_type": "LITERAL"},
		{"principal": "User:" + topicServiceAccountID, "permission": "ALLOW", "operation": "READ", "resource_type": "TOPIC", "resource_name": "squad_raw_service_example_2_entity", "pattern_type": "LITERAL"},
		{"principal": "User:" + topicServiceAccountID, "permission": "ALLOW", "operation": "WRITE", "resource_type": "TOPIC", "resource_name": "squad_raw_service_example_1_entity", "pattern_type": "LITERAL"},
		{"principal": "User:" + topicServiceAccountID, "permission": "ALLOW", "operation": "WRITE", "resource_type": "TOPIC", "resource_name": "squad_raw_service_example_2_entity", "pattern_type": "LITERAL"},
	}

	// Validate Topic ACL data
	actualTopicACLOutput := runCLICommand(t, "confluent", "kafka", "acl", "list", "--service-account", topicServiceAccountID, "-o", "json")
	var topicACLs []map[string]interface{}
	err := json.Unmarshal([]byte(actualTopicACLOutput), &topicACLs)
	a.NoError(err, "Failed to parse Kafka ACL JSON output")
	a.Equal(expectedTopicACLData, topicACLs)
	log.Printf("Successfully validated ACL data for topic service account: %s", topicServiceAccountID)

	// Validate Connector ACL Data
	actualConnectorACLOutput := runCLICommand(t, "confluent", "kafka", "acl", "list", "--service-account", connectorServiceAccountID, "-o", "json")
	var connectorACLs []map[string]interface{}
	err = json.Unmarshal([]byte(actualConnectorACLOutput), &connectorACLs)
	a.NoError(err, "Failed to parse Kafka ACL JSON output")
	a.Equal(expectedConnectorACLData, connectorACLs)
	log.Printf("Successfully validated ACL data for connector service account: %s", connectorServiceAccountID)
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
