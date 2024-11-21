variable "region_name" {
  description = "The AWS region to deploy resources in"
}
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
}
variable "vpc_tag_name" {
  description = "The tag name for the VPC"
}
variable "ig_tag_name" {
  description = "The tag name for the Internet Gateway"
}
variable "public_subnet1_cidr" {
  description = "The CIDR block for the first public subnet"
}
variable "public_subnet2_cidr" {
  description = "The CIDR block for the second public subnet"
}
variable "public_subnet3_cidr" {
  description = "The CIDR block for the third public subnet"
}
variable "public_subnet1_name" {
  description = "The name for the first public subnet"
}
variable "public_subnet2_name" {
  description = "The name for the second public subnet"
}
variable "public_subnet3_name" {
  description = "The name for the third public subnet"
}
variable "rt_cidr_block" {
  description = "The CIDR block for the route table"
}
variable "rt_tag_name" {
  description = "The tag name for the route table"
}
variable "key_name" {
  description = "The name of the key pair to use for EC2 instances"
}
variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "environment" {
  description = "The environment to deploy (e.g., dev, test, prod)"
  default     = "dev"
}
variable "instance_type" {
  description = "The instance type to use for EC2 instances"
  type        = map(string)
  default = {
    dev  = "t2.nano"
    test = "t2.micro"
    prod = "t2.medium"
  }
}
variable "amis" {
  description = "AMIs by region"
  type        = map(string)
  default = {
    us-east-1 = "ami-97785bed" # ubuntu 14.04 LTS
    us-east-2 = "ami-f63b1193" # ubuntu 14.04 LTS
    us-west-1 = "ami-824c4ee2" # ubuntu 14.04 LTS
    us-west-2 = "ami-f2d3638a" # ubuntu 14.04 LTS
  }
}
variable "env" {}
