terraform {
  required_version = ">= 0.13"

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 1.0"
    }
  }
}
