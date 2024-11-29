terraform {
  required_version = ">= 1.9"

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.2"
    }
  }
}
