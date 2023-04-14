
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.bucket.bucket
  policy = templatefile("./modules/s3/s3-policy.json", { bucket = var.bucket_name, distribution = var.origin_access })

}

resource "aws_s3_bucket_public_access_block" "buckey_publicy" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "objects" {
  count        = length(var.objects)
  bucket       = aws_s3_bucket.bucket.id
  key          = var.objects[count.index].key
  source       = var.objects[count.index].source
  content_type = var.objects[count.index].content_type
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags = {
    "Name"         = var.bucket_name,
    "environment"  = "pdn",
    "project-name" = "modelo-de-crecimiento",
    "owner"        = "Joseph-Rojas",
    "area"         = "cloud-ops",
    "provisioned"  = "terraform",
    "cost-center"  = "9904"
  }
}
