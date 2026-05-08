## configure outputs for the project


output "instance_public_ip" {
    description = "Public IP"
    value = aws_instance.ubuntu-server.public_ip
  
}


output "instance_id" {
  description = "EC2 instance Id"
  value = aws_instance.ubuntu-server.id
}


output "ami_used" {
  description = "Ubuntu ami used"
  value = data.aws_ami.ubuntu.id
}


output "vpc_id" {
    description = "ID od the created VPC"
    value = aws_vpc.main.id
}


output "subnet_id" {
  description = "subnet used id"
  value = aws_subnet.public-subnet.id
}

output "ssh_command" {
  description = "ssh command"
  value = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.ubuntu_server.public_ip}"
}