data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-vpc"
  }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.environment}-public-subnet"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.environment}-rtb"
  }
  
}


resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.rtb.id
}


resource "aws_security_group" "ec2_sg" {
  name = "${var.environment}-ec2-sg"
  description = "Allow HTTP and SSH access on EC2 instance"
  vpc_id = aws_vpc.main.id

  ingress { 
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ec2-sg-04"
  }
}


resource "aws_instance" "ubuntu-server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name = var.key_name

  tags = {
    Name = "${var.environment}-ec2-server-04"
  }
}
