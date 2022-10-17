terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.34.0"
    }
  }
}

provider "aws" {
   
}

variable "cidr_blocks" {
  description = "cidr for vpc and subnet"
  type = list(string)
}

variable avail_zone{

}

#variable "subnetcidr" {
#  description = "cidr for subnet"
#  type = string
#}

#variable "availzone" {
#  description = "variable for avalabilty zone"
#  default = "ap-south-1a"
#  type = string
#}

resource "aws_vpc" "octvpc" {
  cidr_block = var.cidr_blocks[0]
  tags = {
    "Name" = "vpc10"
  }
}

resource "aws_subnet" "octsub" {
  vpc_id = aws_vpc.octvpc.id
  cidr_block = var.cidr_blocks[1]
  availability_zone = var.avail_zone
  tags = {
    "Name" = "sub10"
  }
}

