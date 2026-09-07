provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "nginx" {

    ami = "ami-081b0a6eac00b4f53"
    instance_type = "t2.micro"
    subnet_id = "subnet-0407b365d2c54434c"
  
}

resource "aws_s3_bucket" "remote-backend-hf" {
    bucket = "remote-backend-hf"
  
}

