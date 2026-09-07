terraform {
  backend "s3" {
    bucket = "tfstate-bucket-shf"
    key    = "hf/terraform.tfstate"
    region = "us-east-1"
  }
}
