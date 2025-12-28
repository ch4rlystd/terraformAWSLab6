#####################
# Terraform provider 
#####################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = var.region
}


#####################
# VPC
#####################
# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.subnet_cidr_vpc
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name = "VPC principal"
  }
}

# Routing Table for Internet Gateway
resource "aws_route_table" "internet_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.all_destination_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Internet Route Table"
  }
}

# Routing table public subnet association with Internet Gateway
resource "aws_route_table_association" "public_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.internet_route_table.id
}

resource "aws_route_table_association" "public_subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.internet_route_table.id
}


# Routing Table for Private Subnet with NAT Gateway
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = var.all_destination_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Private Route Table with nat gateway"
  }
}

# Routing table private subnet association with NAT Gateway
resource "aws_route_table_association" "private_subnet1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}


#####################
# SUBNETS
#####################
# PUBLIC SUBNET
# Public subnet 1
resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.public_subnet_cidr[0]
  vpc_id                  = aws_vpc.main_vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.availability_zones[0]

  tags = {
    Name = "Public Subnet 1"
  }
}

# Public subnet 2
resource "aws_subnet" "public_subnet2" {
  cidr_block              = var.public_subnet_cidr[1]
  vpc_id                  = aws_vpc.main_vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.availability_zones[1]

  tags = {
    Name = "Public Subnet 2"
  }
}

# PRIVATE SUBNET
# Private subnet 1
resource "aws_subnet" "private_subnet1" {
  cidr_block        = var.private_subnet_cidr[0]
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "Private Subnet 1"
  }
}

# Private subnet 2
resource "aws_subnet" "private_subnet2" {
  cidr_block        = var.private_subnet_cidr[1]
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "Private Subnet 2"
  }
}


#####################
# INTERNET GATEWAY
#####################
# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
  region = var.region

  tags = {
    Name = "Internet Gateway"
  }
}


#####################
# NAT GATEWAY
#####################
# Elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Name = "NAT Gateway EIP_public_1"
  }
}

# Nat Gateway in public subnet 1
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  depends_on = [aws_internet_gateway.gw] # Recommended

  tags = {
    Name = "NAT Gateway public 1"
  }
}


#####################
# AWS EC2 INSTANCE
#####################
# aws security group web_server_1
resource "aws_security_group" "web_server_1_sg" {
  name        = "web_server_1_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "Allow HTTP and SSH traffic on web_server_1"
  }
}

# aws security group web_server_1 ingress rules
resource "aws_vpc_security_group_ingress_rule" "web_server_1_sg_ingress_http" {
  cidr_ipv4         = var.all_destination_cidr
  from_port         = var.web_port
  ip_protocol       = "tcp"
  to_port           = var.web_port
  security_group_id = aws_security_group.web_server_1_sg.id

  tags = {
    Name = "Allow inbound HTTP traffic on web_server_1"
  }
}

# aws security group web_server_1 egress rules
resource "aws_vpc_security_group_egress_rule" "web_server_1_sg_egress" {
  ip_protocol       = "-1" # all protocols
  cidr_ipv4         = var.all_destination_cidr
  security_group_id = aws_security_group.web_server_1_sg.id

  tags = {
    Name = "Allow all outbound traffic on web_server_1"
  }
}


# Instance EC2 web_server_1
resource "aws_instance" "web_server_1" {
  ami                         = data.aws_ssm_parameter.amzn2_linux.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet2.id
  vpc_security_group_ids      = [aws_security_group.web_server_1_sg.id]
  user_data_replace_on_change = true

  # User data for web server
  user_data = <<EOF
  #! /bin/bash
  sudo amazon-linux-extras install -y nginx1
  systemctl enable nginx
  sudo systemctl start nginx
  EOF
}

#####################
# DB RDS
#####################
# RDS Private subnet 1

