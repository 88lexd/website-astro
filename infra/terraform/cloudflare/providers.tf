terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.51"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "cloudflare" {}