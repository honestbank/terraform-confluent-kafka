terraform {
  required_version = ">= 0.13"

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = ">= 2.11.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.2"
    }
  }
}
