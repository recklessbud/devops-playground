# Input variables for the EC2 instance


variable "aws_region" {
  description = "AWS region where resources will bw located"
  type = string
  default = "us-east-1"


  validation {
    condition = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = " AWS region must be in valid format (e.g., us-east-1, eu-west-1)."
  }
}


variable "environment" {
  description = "environment name for resource tagging and naming"
  type = string
  default = "dev"


  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "env must be on of dev, prod, staging"
  }
}

variable "vpc_cidr" {
  description = "VPC cidr"
  type = string
  default = "192.168.0.0/16"
}



variable "instance_type" {
  description = "instance_type"
  type = string
  default = "t2.micro"
}


variable "key_name" {
  description = "key for ssh"
  type = string
  default = "key600.pem"
}

variable "subnet_cidr" {
  description = "subnet cidr"
  type = string
  default = "192.168.1.0/24"
}