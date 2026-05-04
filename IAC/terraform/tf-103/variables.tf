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


variable "instance_type" {
  description = "EC2 instance type to launch template"
  type = string
  default = "t2.micro"

  validation {
    condition = can(regex("^[a-z][0-9][a-z]?\\.(nano|micro|small|medium|large|xlarge|[0-9]+xlarge)$", var.instance_type))
    error_message = "Instance type must be a valid EC2 instance type (e.g., t2.micro, m5.large)."
  }
}


variable "min_size" {
  description = "minimum number of instance in the auto scaling group"
  type = number
  default = 1


  validation {
    condition = var.min_size >= 0 && var.min_size <= 100
    error_message = "Minimun size must be between 0 and 100"
  }
}


variable "max_size" {
  description = "Maximum number of instances in auto scaling groups"
  type = number
  default = 4

  validation {
    condition = var.max_size >= 1 && var.max_size <= 100
    error_message = "Maximum size must be between 1 and 100"
  }
}


variable "desired_capacity" {
  description = "Desired number of instances in auto scaling groups"
  type = number
  default = 2

  validation {
    condition = var.desired_capacity >= 0 && var.desired_capacity <= 100
    error_message = "Desired size must be between 1 and 100"
  }
}



variable "target_cpu_utilization" {
  description = "Target Cpu utilization for auto scaling groups"
  type = number
  default = 70

  validation {
    condition = var.target_cpu_utilization >= 10 && var.target_cpu_utilization <= 90
    error_message = "Target Cpu utilization must be between 1 and 90"
  }
}


variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type = number
  default = 300

  validation {
    condition = var.health_check_grace_period >= 0 && var.health_check_grace_period <= 7200
    error_message = "Health check grace period must be between 1 and 7200 seconds"
  }
}


variable "scale_out_cooldown" {
  description = "Amount of time (in seconds) after a scaling activity completes before another scaling activity can start (scale out)"
  type        = number
  default     = 300
  
  validation {
    condition = var.scale_out_cooldown >= 0 && var.scale_out_cooldown <= 3600
    error_message = "Scale out cooldown must be between 0 and 3600 seconds."
  }
}

variable "scale_in_cooldown" {
  description = "Amount of time (in seconds) after a scaling activity completes before another scaling activity can start (scale in)"
  type        = number
  default     = 300
  
  validation {
    condition = var.scale_in_cooldown >= 0 && var.scale_in_cooldown <= 3600
    error_message = "Scale in cooldown must be between 0 and 3600 seconds."
  }
}


variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the instances via HTTP and SSH"
  type        = list(string)
  default     = ["0.0.0.0/0", "192.168.0.0/16", "192.168.1.0/24", "192.168.2.0/24"]
  
  validation {
    condition = alltrue([
      for cidr in var.allowed_cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "All CIDR blocks must be valid (e.g., '0.0.0.0/0', '10.0.0.0/8')."
  }
}


variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring for EC2 instances"
  type        = bool
  default     = false
}

variable "enable_public_ip" {
  description = "Associate a public IP address with instances"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}