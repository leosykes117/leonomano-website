terraform {
  required_version = "~> 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66.1"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.39.0"
    }
  }
}
