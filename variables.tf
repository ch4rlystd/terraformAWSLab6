#####################
# Configuration AWS PROVIDER REGION
#####################
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

#####################
# CONFIFG VPC
#####################
# Configuration VPC CIDR BLOCK
variable "subnet_cidr_vpc" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Configuration DNS HOSTNAMES
variable "dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = ""
}

#####################
# CONFIG SUBNETS
#####################
# Configuration map_public_ip_on_launch PUBLIC SUBNET
variable "map_public_ip_on_launch" {
  description = "Enable automatic assignment of public IPv4 addresses to instances"
  type        = bool
  default     = true
}

# Configuration CIDR Public Subnet 
variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = list(string)
  default = ["10.0.0.0/24","10.0.2.0/24"]
}

# Configuration CIDR Private Subnet
variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = list(string)
  default = ["10.0.1.0/24","10.0.3.0/24"]
}

# Availiability Zones
variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

