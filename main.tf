provider "aws" {
  region = var.region_name
}

terraform {
  backend "s3" {
    bucket = "terra-workspace-bucket"
    key    = "workspace.tfstate"
    region = "us-east-1"
    #dynamodb_table = "dynamodb-state-locking"
  }
}
resource "aws_vpc" "vpc-terraform" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_tag_name
    service     = local.service
    owner       = local.owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}

resource "aws_internet_gateway" "Ig-Terraform" {
  vpc_id = aws_vpc.vpc-terraform.id

  tags = {
    Name    = "${var.vpc_tag_name}-igw"
    Service = "Terraform"
  }
}
resource "aws_route_table" "public-rt-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.Ig-Terraform.id
  }
  tags = {
    Name        = "${var.vpc_tag_name}-Public-RT"
    service     = local.service
    owner       = local.owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}
resource "aws_route_table" "private-rt-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id

  tags = {
    Name        = "${var.vpc_tag_name}-Private-RT"
    service     = local.service
    owner       = local.owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidr_block)
  vpc_id                  = aws_vpc.vpc-terraform.id
  cidr_block              = element(var.public_cidr_block, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_tag_name}-Public-Subnet-${count.index}"
    service     = local.service
    owner       = local.owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_cidr_block)
  vpc_id                  = aws_vpc.vpc-terraform.id
  cidr_block              = element(var.private_cidr_block, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index + 1)

  tags = {
    Name        = "${var.vpc_tag_name}-Private-Subnet-${count.index}"
    service     = local.service
    owner       = local.owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}


resource "aws_route_table_association" "public-rt-terraform-association" {
  count          = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public-rt-terraform.id
}
resource "aws_main_route_table_association" "disable_main_rt" {
  vpc_id         = aws_vpc.vpc-terraform.id
  route_table_id = aws_route_table.public-rt-terraform.id
}
resource "aws_route_table_association" "private-rt-terraform-association" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private-rt-terraform.id
}