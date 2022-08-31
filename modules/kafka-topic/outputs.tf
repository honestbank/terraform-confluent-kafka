output "topic_name" {
  description = "Kafka topic"
  value       = confluent_kafka_topic.topic.topic_name
}
