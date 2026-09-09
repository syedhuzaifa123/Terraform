provider "aws" {
    region = "us-east-1"
}

variable "ami" {
  description = "for ami ID"
}

variable "instance_type" {
  description = "for instance type"
}


resource "aws_instance" "nginx" {
  ami = var.ami
  instance_type = var.instance_type
}
