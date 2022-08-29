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
	t.Parallel()

	runID := strings.ToLower(random.UniqueId())

	clusterName := "test-cluster-" + runID

	applyDestroyTestCaseName := "apply_destroy_" + clusterName
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

	fmt.Printf("Got confluent credentials. Key/secret lengths %d/%d", len(cloudAPIKey), len(cloudAPISecret))

	t.Run(applyDestroyTestCaseName, func(t *testing.T) {
		a := assert.New(t)
		t.Parallel()
		workingDir = test_structure.CopyTerraformFolderToTemp(t, "..", "examples/create-env-cluster-topics")
		runOptions := &terraform.Options{}
		test_structure.RunTestStage(t, "create topics", func() {
			runOptions = terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: workingDir,
				EnvVars:      map[string]string{},
				Vars: map[string]interface{}{
					"environment":                "test",
					"confluent_cloud_api_key":    cloudAPIKey,
					"confluent_cloud_api_secret": cloudAPISecret,
				},
			})
		})

		defer terraform.Destroy(t, runOptions)
		terraform.InitAndApply(t, runOptions)

		var output string

		output = terraform.Output(t, runOptions, "environment_name")
		a.Equal(output, "honest-labs-test")

		output = terraform.Output(t, runOptions, "environment_id")
		a.NotEmpty(output)

		output = terraform.Output(t, runOptions, "kafka_cluster_basic_name")
		a.True(strings.Contains(output, "kafka-labs-1-basic"))

		output = terraform.Output(t, runOptions, "topic_service_account_key")
		a.NotEmpty(output)

		output = terraform.Output(t, runOptions, "kafka_topic_name")
		a.Equal(output, "squad-raw.service-example.entity")
	})
}
