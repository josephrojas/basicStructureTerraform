resource "aws_cloudfront_origin_access_identity" "oai_cludfront" {
    comment = "Origin access Identity of S3"
}


resource "aws_cloudfront_distribution" "s3_test_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket_website.bucket_regional_domain_name
    origin_id = var.cloudfront_origin

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai_cludfront.cloudfront_access_identity_path
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