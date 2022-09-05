output "topic_id" {
  description = "The ID of the Kafka topic, in the format `<Kafka cluster ID>/<Kafka Topic name>`, for example, `lkc-abc123/topic-1`."
  value       = confluent_kafka_topic.topic.id
}

output "topic_name" {
  description = "The name of the topic"
  value       = confluent_kafka_topic.topic.topic_name
}
