terraform {
  backend "s3" {
    bucket = "remote-backend-hf"
    key    = "hf/terraform.tfstate"
    region = "us-east-1"
  }
}
