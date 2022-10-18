terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.35.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env {}


#Create a VPC
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env}-vpc"
  }
}

#Create a subnet
resource "aws_subnet" "myapp_subnet1" {
  vpc_id = aws_vpc.myapp_vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    "Name" = "${var.env}-subnet1"
  }
}


#Create a routetable

resource "aws_route_table" "myapprtb" {
  vpc_id = aws_vpc.myapp_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp_itg.id
  }
  tags = {
    "Name" = "${var.env}-rtb"
  }
}

#Create InternetGateway

resource "aws_internet_gateway" "myapp_itg" {
  vpc_id = aws_vpc.myapp_vpc.id
  tags = {
    "Name" = "${var.env}-itg"
  }
}

#Create routetable association

resource "aws_route_table_association" "rtb_subnet1" {
  subnet_id = aws_subnet.myapp_subnet1.id
  route_table_id = aws_route_table.myapprtb.id
}
