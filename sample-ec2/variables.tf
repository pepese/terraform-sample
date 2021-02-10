#####################################
# constant
#####################################

locals {
  base_tags = {
    Project     = var.project
    Terraform   = "true"
    Env = var.env
  }
  base_name       = "${var.project}-${var.env}"
}

#####################################
# variable
#####################################

variable "access_key" {}

variable "secret_key" {}

variable "project" {
  default = "pepese"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "env" {
  default = ""
}

variable "state_bucket" {
  default = ""
}

variable "state_key" {
  default = ""
}

variable "state_key_vpc" {
  default = ""
}

variable "ami" {
  default = ""
}

variable "instance_type" {
  default = ""
}