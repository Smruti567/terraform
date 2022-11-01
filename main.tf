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
#variable avail_zone {}
variable env {}
variable myip {}
variable instance_type {}
  

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
  #availability_zone = var.avail_zone
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

#Create security group

resource "aws_security_group" "myapp_sg" {
  name = "myapp_sg"
  vpc_id = aws_vpc.myapp_vpc.id

 ingress {
    description = "SSH from my system"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.myip]
  }

  ingress {
    description = "8080 from vpc"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

## Outbound traffic for any port, any protocol, any
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env}-sg"
  }
  
}


#Create EC2 instance

# EC2 instance from ami
/*resource "aws_instance" "myapp-EC2" {
  ami = "ami-0e6329e222e662a52"
}*/
resource "aws_instance" "myappserver" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id =  aws_subnet.myapp_subnet1.id
  vpc_security_group_ids = [aws_security_group.myapp_sg.id]

  associate_public_ip_address = true
  key_name = "dfg"

  tags = {
    "Name" = "${var.env}-server"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  
}

/*output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image
  
}*/


