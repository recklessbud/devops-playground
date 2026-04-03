# 01-VPC — AWS Private/Public Subnet Architecture
 
A hands-on project where I built a basic AWS VPC with a public and private subnet, deployed two EC2 instances, and configured Nginx on the public instance to reverse proxy traffic to a server running in the private subnet.
 
## What I did
 
- Created a VPC with a public and private subnet
- Launched an EC2 instance in each subnet
- Used the public EC2 as an Nginx reverse proxy
- Served a static HTML page from the private EC2 using Python's `http.server`
- Configured Security Groups to allow traffic between the instances
- SSH'd into the private EC2 via the public EC2 (bastion hop)
 
## Full Write-up
 
I documented the full process, including mistakes and fixes, on Dev.to:
 
👉 [Read the full article](https://dev.to/recklessbud_19/01-vpc-aws-privatepublic-subnet-architecture-47be) 
 
---