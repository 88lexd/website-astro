terraform {
  backend "s3" {
    bucket = "lexd-solutions-tfstate"
    key    = "terraform/newrelic.tfstate"
    region = "ap-southeast-2"
  }
}
