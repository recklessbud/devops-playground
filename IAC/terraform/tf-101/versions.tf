# Terraform versions and provider configuration
terraform {
    required_version = ">= 1.0.0"
    required_providers {
        aws = {
            source = "hashcorp/aws"
            versions = "~> 5.0"
        }

        random = {
            source = "hashcorp/random"
            version = "~> 3.1" 
        }
    }

}



provider "aws" {
  region = var.aws_region
}