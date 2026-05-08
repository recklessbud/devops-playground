# main.tf
# Ec2 launch Templates and Auto Scaling Group insfrastructure

# generate a random sufffix for unique resource naming

resource "random_id" "suffix" {
  byte_length = 5
}


locals {
  name_prefix = "${var.environment}-autoscaling-${random_id.suffix.hex}"
}

locals {
  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    environment = var.environment
  }))
}





# creating a new vpc
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${local.name_prefix}-vpc"
  }

}

resource "aws_subnet" "subnet04" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${local.name_prefix}-subnet"
  }
}

resource "aws_subnet" "subnet05" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.subnet_2_cidr_block
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${local.name_prefix}-subnet-05"
  }
}


# data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "state"
    values = ["available"]
  }
}


# security groups for ec2 instances
resource "aws_security_group" "server_sg" {
  name_prefix = "${local.name_prefix}-sg-"
  description = "Security group for Auto scaling dummy web servers"
  vpc_id = aws_vpc.main_vpc.id


  ingress {
    description = "Allow HTTP access on port 8080"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "Allow SSH access on port 22"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-securtiy-group"
  }

  lifecycle {
    create_before_destroy = true
  }

}



resource "aws_iam_role" "ec2_role" {
  name_prefix = "${local.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {Service ="ec2.amazonaws.com" }
      }
    ]
  })
  tags = {
    Name = "${local.name_prefix}-assume-role"
  }
} 


# attach cloudwatch agent server policy to the IAM role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
 role = aws_iam_role.ec2_role.name 
 policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

}


resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name_prefix = "${local.name_prefix}-ec2-profile-"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name = "${local.name_prefix}-ec2-profile"
  }
}

resource "aws_launch_template" "web_servers" {
  name_prefix = "${local.name_prefix}-lt-"
  description = "Launch templates for EC2 instances in Auto Scaling group"
  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  
  network_interfaces {
    associate_public_ip_address = var.enable_public_ip
    security_groups = [ aws_security_group.server_sg.id ]
    delete_on_termination = true
  }


  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  
  user_data = local.user_data

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.name_prefix}-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${local.name_prefix}-volume"
    }
  }

  # launch template tags
  tags = {
    Name = "${local.name_prefix}-launch-template-"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_servers_2" {
  name = "${local.name_prefix}-asg"
  vpc_zone_identifier = [aws_subnet.subnet04.id, aws_subnet.subnet05.id]

  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity


  health_check_type = "EC2"
  health_check_grace_period = var.health_check_grace_period


  launch_template {
    id = aws_launch_template.web_servers.id
    version = "$Latest"
  }

# Enable instance refresh for updates
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  metrics_granularity = "1Minute"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances"
  ]

    tag {
    key                 = "Name"
    value               = "${local.name_prefix}-asg"
    propagate_at_launch = false
  }
  
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Project"
    value               = "EC2-Auto-Scaling-Demo"
    propagate_at_launch = true
  }
  
  # Dynamic tags from variables
  dynamic "tag" {
    for_each = var.additional_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  
  lifecycle {
    create_before_destroy = true
    ignore_changes       = [desired_capacity]
  }
  
  depends_on = [
    aws_launch_template.web_servers
  ]
}



# Target Tracking Scaling Policy for CPU Utilization
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name               = "${local.name_prefix}-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web_servers_2.name
  policy_type       = "TargetTrackingScaling"
  
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    
    target_value     = var.target_cpu_utilization
    scale_out_cooldown = var.scale_out_cooldown
    scale_in_cooldown  = var.scale_in_cooldown
  }
  
  depends_on = [aws_autoscaling_group.web_servers_2]
}


# CloudWatch Dashboard for monitoring (optional)
resource "aws_cloudwatch_dashboard" "auto_scaling_dashboard" {
  dashboard_name = "${local.name_prefix}-dashboard"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        
        properties = {
          metrics = [
            ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", aws_autoscaling_group.web_servers_2.name],
            [".", "GroupInServiceInstances", ".", "."],
            [".", "GroupMinSize", ".", "."],
            [".", "GroupMaxSize", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Auto Scaling Group Metrics"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        
        properties = {
          metrics = [
                   ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.web_servers_2.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Average CPU Utilization"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }
    ]
  })
}