terraform {
  required_version = "~> 1.1.6"
}
provider "aws" {
  region  = "${var.region}"
}
