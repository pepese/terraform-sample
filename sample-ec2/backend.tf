terraform {
  backend "s3" {
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = var.state_key_vpc
    region = var.region
  }
}