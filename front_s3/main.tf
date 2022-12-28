provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "bucket_website" {
  bucket = var.bucket_name
  tags_all = {
    "Name" = "bucket_website_terraform"
  }
}

