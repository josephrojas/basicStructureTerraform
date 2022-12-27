
output "website_domain" {
  value = aws_s3_bucket.bucket_website.bucket_domain_name
}

output "domain_name" {
    value = aws_cloudfront_distribution.s3_test_distribution.domain_name
}

output "hosted_zone_id" {
  value = aws_cloudfront_distribution.s3_test_distribution.hosted_zone_id
}