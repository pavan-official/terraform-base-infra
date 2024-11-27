variable "region_name" {}
variable "vpc_cidr_block" {}
variable "public_cidr_block" {}
variable "public_subnet_tag_name" {}
variable "private_cidr_block" {}
variable "private_subnet_tag_name" {}
variable "vpc_tag_name" {}
variable "rt_cidr_block" {}
variable "key_name" {}
variable "azs" {}
variable "environment" {}
variable "ingress_rules" {
  type = list(map(string))
}
variable "egress_rules" {
  type = list(map(string))
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
variable "amis" {}
variable "env" {}
