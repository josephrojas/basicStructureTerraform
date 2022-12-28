resource "aws_s3_bucket_acl" "site" {
  bucket = aws_s3_bucket.bucket_website.id
  acl = "private"
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.bucket_website.bucket
  policy = templatefile("s3-policy.json", { bucket = var.bucket_name , 
  distribution = aws_cloudfront_origin_access_identity.oai_cludfront.iam_arn})

}

resource "aws_s3_bucket_public_access_block" "buckey_publicy" {
  bucket = aws_s3_bucket.bucket_website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "website_objects" {
  for_each = fileset("../../three-test/","*")
  bucket = aws_s3_bucket.bucket_website.id
  key = each.value
  source = "../../three-test/${each.value}"
  content_type = "${var.content_type[each.value]}"
}