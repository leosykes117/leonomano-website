terraform {
  required_version = "~> 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66.1"
    }

    godaddy = {
      source  = "n3integration/godaddy"
      version = "~> 1.9.1"
    }
  }
}
