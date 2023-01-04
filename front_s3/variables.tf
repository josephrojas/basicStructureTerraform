variable "bucket_name" {
  type    = string
  default = "s3-public-website-terraform"
}

variable "cloudfront_origin" {
  type = string
  default = "website-test"
}

variable "content_type" {
  type = map(string)
  default = {
    "index.html" = "text/html"
    "app.js" = "application/javascript"
    "style.css" = "text/css"
    "error.html" = "text/html"
    "appError.js" = "application/javascript"
   }
}

variable "acl_name" {
  type = string
  default = "web_acl_s3"
}
