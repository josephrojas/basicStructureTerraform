provider "aws" {
  region = "us-east-2"
}

//Provider to waf
provider "aws" {
  alias = "provider_waf"
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket_website" {
  bucket = var.bucket_name
  tags_all = {
    "Name" = "bucket_website_terraform"
  }
}

