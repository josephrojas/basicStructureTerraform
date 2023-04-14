resource "aws_cloudfront_origin_access_identity" "oai_cludfront" {
    comment = "Origin access Identity of S3"
}


resource "aws_cloudfront_distribution" "front_distribution" {
  origin {
    domain_name = var.domain_name
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
      restriction_type = "blacklist"
      locations = ["US","SE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  web_acl_id = var.waf

  tags = {
    "Name"         = "pragma-modelo-de-crecimiento-pdn-cloudfront",
    "environment"  = "pdn",
    "project-name" = "modelo-de-crecimiento",
    "owner"        = "Joseph-Rojas",
    "area"         = "cloud-ops",
    "provisioned"  = "terraform",
    "cost-center"  = "9904"
  }

}