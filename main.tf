terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.28"
    }
  }
 backend "s3" {
    bucket         	   = "noel-terraform-state-bucket123456"
    key              	   = "state/terraform.tfstate"
    region         	   = "us-east-1"
 
  }
}

provider "aws" {
  # Configuration options
  alias = "us-east-1"
  region = "us-east-1"
}