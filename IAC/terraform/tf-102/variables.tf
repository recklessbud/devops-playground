# Various input varibles for the AWS public/private subnet architecture

variable "aws_region" {
    description = "AWS region for resources"
    type = string
    default = "us-east-1"

    validation {
      condition = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
      error_message = "AWS region must be in a vlaid format"
    }
}


variable "environment" {
    description = "Environment name for resource tagging and naming"
    type = string
    default = "dev"

    validation {
        condition     = contains(["dev", "staging", "prod"], var.environment)
        error_message = "Environment must be one of: dev, staging, prod."
    }
}

variable "project_name" {
  description = "Name of the project for resource naming and tagging"
  type        = string
  default     = "public-private-subnet-architecture"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
  
  validation {
    condition = alltrue([
      for key, value in var.tags : can(regex("^[a-zA-Z0-9\\s._:/=+@-]*$", key)) && can(regex("^[a-zA-Z0-9\\s._:/=+@-]*$", value))
    ])
    error_message = "Tag keys and values must contain only valid characters."
  }
}



# vpc

variable "vpc_display_name" {
  description = "Display name for the VPC"
  type        = string
  default     = "Main VPC"
}

variable "vpc_cidr" {
  description = "Vpc-cidr"
  type = string
  default = "192.168.0.0/16"

  validation {
    condition = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must ba a valid Cidr block"
  }

}


variable "public_subnet_cidr" {
  description = "Public subnet cidr"
  type = string
  default = "192.168.1.0/24"
}


variable "private_subnet_cidr" {
  description = "Private subnet cidr"
  type = string
  default = "192.168.2.0/24"
}



# EC2 instances
variable "instance_type" {
  description = "instance type"
  type = string
  default = "t2.micro"
 validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Must be a valid free-tier or small instance type."
  }
}


variable "key_name" {
  description = "key for ssh"
  type = string
  default = "key600"
}