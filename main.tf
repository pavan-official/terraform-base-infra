
provider "aws" {
  region = var.region_name
}
resource "aws_vpc" "vpc-Terraform" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = var.vpc_tag_name
    service = "Terraform"
  }
}

resource "aws_internet_gateway" "Ig-Terraform" {
  vpc_id = aws_vpc.vpc-Terraform.id

  tags = {
    Name    = var.ig_tag_name
    Service = "Terraform"
  }
}

resource "aws_subnet" "Public-Subnet-Terraform" {
  vpc_id                  = aws_vpc.vpc-Terraform.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_az

  tags = {
    Name    = var.subnet_tag_name
    Service = "Terraform"
  }
}

resource "aws_route_table" "Public-RT-Terraform" {
  vpc_id = aws_vpc.vpc-Terraform.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.Ig-Terraform.id
  }
  tags = {
    Name    = var.rt_tag_name
    Service = "Terraform"
  }
}
resource "aws_route_table_association" "Public-RT-Terraform" {
  subnet_id      = aws_subnet.Public-Subnet-Terraform.id
  route_table_id = aws_route_table.Public-RT-Terraform.id
}

resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.vpc-Terraform.id

  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "SG-Terra"
    Service = "Terraform"
  }
}

resource "aws_instance" "web-1" {
  ami                         = "ami-0866a3c8686eaeeba"
  availability_zone           = var.ec2_az
  instance_type               = var.ec2_instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.Public-Subnet-Terraform.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Prod-Server"
    Env        = "Prod"
    Owner      = "pavan"
    CostCenter = "ABCD"
  }
  lifecycle {
    prevent_destroy = true
  }
}