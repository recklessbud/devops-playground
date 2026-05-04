# Main terraform configuration file

data "aws_caller_identity" "current" {}

resource "random_string" "suffix" {
  length = 6
  upper = false
  special = false
}



locals {
vpc_name = "${var.environment}-vpc-${random_string.suffix.result}"
public_subnet = "${var.environment}-public-subnet-${random_string.suffix.result}"
private_subnet = "${var.environment}-private-subnet-${random_string.suffix.result}"
internet_gateway = "${var.environment}-igw-${random_string.suffix.result}"
}

# VPC
resource "aws_vpc" "main_vpc" {  
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }

}


# Public Subnet

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = local.public_subnet
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = local.private_subnet
  }
}

# internet gateway for vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = local.internet_gateway
  }
}


# route table for public subnet

resource "aws_route_table" "rtb_public" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags= {
        Name = "${var.environment}-rtb-public"
    }
}


resource "aws_route_table_association" "assoc_public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.rtb_public.id
  
}


# EC2 instances

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners = ["099720109477"]
  
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
}

# security for both ec2s in one group
resource "aws_security_group" "ec2_sg_public" {
  name = "${var.environment}-ec2-sg-04"
  description = "Allow HTTP and SSH access on EC2 instance"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
}

resource "aws_security_group" "ec2_sg_private" {
  name = "${var.environment}-ec2-sg-05"
  description = "Allow HTTP and SSH access on EC2 instance"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.ec2_sg_public.id ]
  }
  ingress {
    description = "HTTP"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_instance" "ubuntu_server_public" {
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg_public.id]
  key_name = var.key_name
  tags = {
    Name = "${var.environment}-ec2-public"
  }
  
}

resource "aws_instance" "ubuntu_server_private" {
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg_private.id]
  key_name = var.key_name
  tags = {
    Name = "${var.environment}-ec2-private"
  }
}