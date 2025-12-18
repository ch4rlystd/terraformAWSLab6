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
  access_key = "" # change
  secret_key = "" # change
}

#####################
# VPC
#####################
# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.subnet_cidr_vpc
  enable_dns_hostnames = var.dns_hostnames
}

#####################
# SUBNETS
#####################
# PUBLIC SUBNET
# Public subnet 1
resource "aws_subnet" "public_subnet1" {
 cidr_block = var.public_subnet_cidr[0]
 vpc_id = var.vpc_id
 map_public_ip_on_launch = var.map_public_ip_on_launch
 availability_zone = var.availability_zones[0]
}

# Public subnet 2
resource "aws_subnet" "public_subnet2" {
 cidr_block = var.public_subnet_cidr[1]
 vpc_id = var.vpc_id
 map_public_ip_on_launch = var.map_public_ip_on_launch
 availability_zone = var.availability_zones[1]
}

# PRIVATE SUBNET
# Private subnet 1
resource "aws_subnet" "private_subnet1" {
 cidr_block = var.private_subnet_cidr[0]
 vpc_id = var.vpc_id 
 availability_zone = var.availability_zones[0]
}

# Private subnet 2
resource "aws_subnet" "private_subnet2" {
 cidr_block = var.private_subnet_cidr[1]
 vpc_id = var.vpc_id
 availability_zone = var.availability_zones[1]
}

