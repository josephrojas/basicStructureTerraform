provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "bucket_website" {
  bucket = var.bucket_name
  tags_all = {
    "Name" = "bucket_website_terraform"
  }
}

resource "aws_s3_bucket_acl" "site" {
  bucket = aws_s3_bucket.bucket_website.id

  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "config_website" {
  bucket = aws_s3_bucket.bucket_website.bucket
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.bucket_website.bucket
  policy = templatefile("s3-policy.json", { bucket = var.bucket_name })

}

resource "aws_s3_object" "website_objects" {
  for_each = fileset("../../three-test/","*")
  bucket = aws_s3_bucket.bucket_website.id
  key = each.value
  source = "../../three-test/${each.value}"
  content_type = "${var.content_type[each.value]}"
}


resource "aws_cloudfront_distribution" "s3_test_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket_website.bucket_regional_domain_name
    origin_id = var.cloudfront_origin

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = false
    allowed_methods = ["GET","HEAD"]
    cached_methods = [ "GET","HEAD" ]
    target_origin_id = var.cloudfront_origin

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags_all = {
    "Name" = "cloudfront-s3"
  }

}