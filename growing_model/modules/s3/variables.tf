variable "bucket_name" {
  type    = string
  default = "s3-public-website-terraform"
}

variable "objects" {
  type = list(object({
    key = string
    source = string
    content_type = string
  }))
}

variable "origin_access" {
  type = string
}