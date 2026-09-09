provider "aws" {
    region = "us-east-1"
  
}

variable "ami" {
  description = "for ami ID"
}

variable "instance_type" {
  description = "for instance type"
  type = map(string)

  default = {
    "dev" = "t2.micro"
    "stage" = "t2.medium"
    "prod" = "t2.large"
  }
}

module "ec2_instance" {
    source = "./module/ec2_instance"
    ami = var.ami
    instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}

