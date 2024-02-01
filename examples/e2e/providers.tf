terraform {
  required_version = ">=1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.50.0"
    }
  }
}
provider "aws" {
  region = "ap-southeast-2"
}
