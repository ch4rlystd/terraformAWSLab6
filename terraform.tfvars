# CONFIGURATION AWS PROVIDER
region = "us-east-1"

#####################
# VPC
#####################
subnet_cidr_vpc = "10.0.0.0/16"
dns_hostnames = true
vpc_id = "" # Change

#####################
# CONFIGURATION SUBNET
#####################
map_public_ip_on_launch = true

# cidr blocks for subnets
public_subnet_cidr=["10.0.0.0/24","10.0.2.0/24"]
private_subnet_cidr=["10.0.1.0/24","10.0.3.0/24"]

# Availiability Zones
availability_zones = ["us-east-1a", "us-east-1b"]