package test

import (
	"fmt"
	"log"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/confluentinc/confluent-kafka-go/kafka"
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
					"environment":                "terratest",
					"confluent_cloud_api_key":    cloudAPIKey,
					"confluent_cloud_api_secret": cloudAPISecret,
				},
			})
		})

		defer terraform.Destroy(t, runOptions)
		terraform.InitAndApply(t, runOptions)

		var output string

		output = terraform.Output(t, runOptions, "environment_name")
		a.True(strings.Contains(output, "honest-labs-terratest"))

		output = terraform.Output(t, runOptions, "environment_id")
		a.NotEmpty(output)

		output = terraform.Output(t, runOptions, "kafka_cluster_basic_name")
		a.True(strings.Contains(output, "kafka-labs-1-basic"))

		output = terraform.Output(t, runOptions, "topic_service_account_key")
		a.NotEmpty(output)

		output = terraform.Output(t, runOptions, "kafka_topic_name")
		a.Equal(output, "squad-raw.service-example.entity")

		topicSAKey := terraform.Output(t, runOptions, "topic_service_account_key")
		topicSASecret := terraform.Output(t, runOptions, "topic_service_account_secret")
		bootstrap := terraform.Output(t, runOptions, "kafka_cluster_basic_bootstrap_endpoint")
		topicName := terraform.Output(t, runOptions, "kafka_topic_name")

		producer := newKafkaProducer(topicSAKey, topicSASecret, bootstrap)
		produceKafkaMessage(producer, topicName, []byte("hello world"))
		producer.Close()

		consumer := newKafkaConsumer(topicSAKey, topicSASecret, bootstrap, "honest_consumer_terratest")
		a.True(consumeKafkaMessage(consumer, topicName))
		consumer.Close()
	})
}

func newKafkaProducer(username string, password string, bootstrap string) *kafka.Producer {
	producer, err := kafka.NewProducer(&kafka.ConfigMap{
		"sasl.username":     username,
		"sasl.password":     password,
		"bootstrap.servers": bootstrap,
		"sasl.mechanisms":   "PLAIN",
		"security.protocol": "SASL_SSL",
	})
	if err != nil {
		fmt.Printf("Failed to create producer: %s", err)
		os.Exit(1)
	}
	return producer
}

func produceKafkaMessage(producer *kafka.Producer, topic string, message []byte) {
	msg := &kafka.Message{
		TopicPartition: kafka.TopicPartition{Topic: &topic, Partition: kafka.PartitionAny},
		Value:          message,
	}
	err := producer.Produce(msg, nil)
	if err != nil {
		log.Fatal(err)
		return
	}
	fmt.Println(producer.Flush(3000))
}

func newKafkaConsumer(username string, password string, bootstrap string, consumerGroup string) *kafka.Consumer {
	consumer, err := kafka.NewConsumer(&kafka.ConfigMap{
		"sasl.username":            username,
		"sasl.password":            password,
		"bootstrap.servers":        bootstrap,
		"sasl.mechanisms":          "PLAIN",
		"security.protocol":        "SASL_SSL",
		"session.timeout.ms":       6000,
		"group.id":                 consumerGroup,
		"auto.offset.reset":        "earliest",
		"enable.auto.offset.store": false,
		"broker.address.family":    "v4",
	})
	if err != nil {
		fmt.Printf("Failed to create producer: %s", err)
		os.Exit(1)
	}
	return consumer
}

func consumeKafkaMessage(consumer *kafka.Consumer, topic string) bool {
	topics := []string{topic}
	err := consumer.SubscribeTopics(topics, nil)
	if err != nil {
		log.Fatalln(err)
		return false
	}
	c1 := make(chan string, 1)
	go func() {
		for {
			message, err := consumer.ReadMessage(100 * time.Millisecond)
			if err == nil {
				fmt.Println(message)
				//err := deser.DeserializeInto(*message.TopicPartition.Topic, message.Value, &received)
				if err != nil {
					fmt.Printf("Failed to deserialize payload: %s\n", err)
				} else {
					c1 <- "success"
					return
				}
			}
		}
	}()
	select {
	case _ = <-c1:
		return true
	case <-time.After(5 * time.Second):
		return false
	}
}
