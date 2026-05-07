# versions and provider configuration
# color palette generator configuration


terraform{
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
      archive = {
        source = "hashicorp/archive"
        version = "~> 2.4"
      }
      random = {
        source = "hashicorp/random"
        version = "~> 3.4"
      }
    }
}



provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = "Simple Color Palette Generator"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Recipe      = "simple-color-palette-generator-lambda-s3"
    }
  }
}



provider "random" {}