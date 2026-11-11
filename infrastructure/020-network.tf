# Network configuration

# VPC creation
resource "aws_vpc" "terraform" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-vpc-http"
  }
}

# http subnet configuration
resource "aws_subnet" "http" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.network_http["cidr"]
  tags = {
    Name = "${terraform.workspace}-subnet-http"
  }
  depends_on = [aws_internet_gateway.gw]
}

# db subnet configuration
resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.network_db["cidr"]
  tags = {
    Name = "${terraform.workspace}-subnet-db"
  }
  depends_on = [aws_internet_gateway.gw]
}

# External gateway configuration
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id
  tags = {
    Name = "${terraform.workspace}-internet-gateway"
  }
}

