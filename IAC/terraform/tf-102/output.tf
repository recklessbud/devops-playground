# output values for the public-private-architecture
output "instance_public_ip" {
  description = "public ec2 ip"
  value = aws_instance.ubuntu_server_public.public_ip
}


output "instance_private_ip" {
  description = "private_ip"
  value = aws_instance.ubuntu_server_private.private_ip
}


output "ami_used" {
  description = "Ubuntu ami used"
  value = data.aws_ami.ubuntu_ami.id
}


output "vpc_id" {
    description = "ID od the created VPC"
    value = aws_vpc.main_vpc.id
}

output "public_subnet_id" {
  description = "public_subnet used id"
  value = aws_subnet.public_subnet.id
}
output "private_subnet_id" {
  description = " private_subnet used id"
  value = aws_subnet.private_subnet.id
}
