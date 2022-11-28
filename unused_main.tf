terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = ${aws_access_key}
  secret_key = ${aws_secret_key}
}


resource "aws_instance" "myFirstwebServer" {
  count = 4
  ami           = "ami-0ee23bfc74a881de5"
  instance_type = "t2.micro"
  tags = {
    Name = "my-machine-${count.index}"
  }
}

/* resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
} */

resource "aws_vpc" "first-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "first-vpc-tag"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "first-vpc-subnet"
  }
}
