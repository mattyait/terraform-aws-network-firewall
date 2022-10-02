terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31.0"
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
}
