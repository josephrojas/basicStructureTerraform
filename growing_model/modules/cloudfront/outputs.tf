output "origin_access" {
  value = aws_cloudfront_origin_access_identity.oai_cludfront.iam_arn
}