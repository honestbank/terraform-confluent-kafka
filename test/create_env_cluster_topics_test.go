package test

import (
	"fmt"
	"os"
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

	cloudAPIKey, exist := os.LookupEnv("TERRATEST_CONFLUENT_CLOUD_SEED_KEY")
	if !exist {
		fmt.Println("TERRATEST_CONFLUENT_CLOUD_SEED_KEY not set")
		os.Exit(1)
	}

	cloudAPISecret, exist := os.LookupEnv("TERRATEST_CONFLUENT_CLOUD_SEED_SECRET")
	if !exist {
		fmt.Println("TERRATEST_CONFLUENT_CLOUD_SEED_SECRET not set")
		os.Exit(1)
	}
	fmt.Printf("Got confluent credentials. Key/secret lengths %d/%d\n", len(cloudAPIKey), len(cloudAPISecret))

	confluentCloudEmail, exist := os.LookupEnv("TERRATEST_CONFLUENT_CLOUD_EMAIL")
	if !exist {
		fmt.Println("TERRATEST_CONFLUENT_CLOUD_EMAIL not set")
		os.Exit(1)
	}

	confluentCloudPassword, exist := os.LookupEnv("TERRATEST_CONFLUENT_CLOUD_PASSWORD")
	if !exist {
		fmt.Println("TERRATEST_CONFLUENT_CLOUD_PASSWORD not set")
		os.Exit(1)
	}
	fmt.Printf("Got confluent cloud credential. Email/Password lengths %d/%d\n", len(confluentCloudEmail), len(confluentCloudPassword))

	GoogleCredentialsJSON, exist := os.LookupEnv("TERRATEST_GOOGLE_CREDENTIALS_STORAGE")
	if !exist {
		fmt.Println("TERRATEST_GOOGLE_CREDENTIALS_STORAGE not set")
		os.Exit(1)
	}
	fmt.Printf("Got Google Credentials. lengths %d\n", len(GoogleCredentialsJSON))

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

		output = terraform.Output(t, runOptions, "environment_id")
		a.NotEmpty(output)

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
	})
}
