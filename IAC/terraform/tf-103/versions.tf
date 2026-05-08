# Provider and version configurations


terraform {
    required_version = ">= 1.0.0"
    required_providers {
        aws = {
            source = "hashcorp/aws"
            version = "~> 5.0"
        }

        random = {
            source = "hashcorp/random"
            version = "~> 3.1" 
        }
    }

}



provider "aws" {
  region = var.aws_region

    default_tags {
    tags = {
      Project     = "EC2-Auto-Scaling-Demo"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Recipe      = "ec2-launch-templates-auto-scaling"
    }
  }
}

# Configure the Random Provider for generating unique resource names
provider "random" {}
