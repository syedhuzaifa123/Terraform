provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "nginx" {

    ami = "ami-081b0a6eac00b4f53"
    instance_type = "t2.micro"
    subnet_id = "subnet-0407b365d2c54434c"
  
}

resource "aws_s3_bucket" "tfstate_bucket_shf" {
    bucket = "tfstate-bucket-shf"
    force_destroy = true
  
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform_lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}