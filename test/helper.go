package test

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/confluentinc/confluent-kafka-go/kafka"
)

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
	timer := time.NewTimer(time.Second * 10)
	c := make(chan string)
	go func() {
		for {
			_, err := consumer.ReadMessage(100 * time.Millisecond)
			if err == nil {
				if err != nil {
					fmt.Printf("Failed to deserialize payload: %s\n", err)
				} else {
					c <- "success"
				}
			}
		}
	}()
	select {
	case <-c:
		return true
	case <-timer.C:
		return false
	}
}

func getClusterState(clusterId string, environmentId string, apiKey string) cluster {
	url := fmt.Sprintf("https://api.confluent.cloud/cmk/v2/clusters/%s?environment=%s", clusterId, environmentId)

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("Authorization", fmt.Sprintf("Basic %s", apiKey))

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var clusterCfg cluster
	err := json.Unmarshal(body, &clusterCfg)
	if err != nil {
		log.Fatalln(err)
	}
	return clusterCfg
}

func getServiceAccountState(serviceAccountId string, authKey string) serviceAccount {
	url := fmt.Sprintf("https://api.confluent.cloud/iam/v2/service-accounts/%s", serviceAccountId)

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("Authorization", fmt.Sprintf("Basic %s", authKey))

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	var sa serviceAccount
	err := json.Unmarshal(body, &sa)
	if err != nil {
		log.Fatalln(err)
	}
	return sa
}
