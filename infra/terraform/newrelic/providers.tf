terraform {
  required_version = "> 1.8"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3"
    }
  }
}

# Provider can read from environment variable
# export NEW_RELIC_ACCOUNT_ID="my-nr-account-id"
# export NEW_RELIC_API_KEY="my-key"
provider "newrelic" {}
