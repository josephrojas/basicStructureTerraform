//Provider to waf
provider "aws" {
  alias = "provider_waf"
  region = "us-east-1"
}

resource "aws_wafv2_web_acl" "acl" {
  provider    = aws.provider_waf
  name        = var.acl_name
  description = "Web acl for ${var.acl_name}"
  scope       = var.scope
  default_action {
    allow {

    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAFWebACL-metric"
    sampled_requests_enabled   = true
  }
  rule {
    name     = "SQLinjectionRule"
    priority = 0
    action {
      block {}
    }
    statement {
      or_statement {
        statement {
          sqli_match_statement {
            field_to_match {
              query_string {

              }
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          sqli_match_statement {
            field_to_match {
              body {

              }
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          sqli_match_statement {
            field_to_match {
              uri_path {

              }
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          sqli_match_statement {
            field_to_match {
              single_header {
                name = "authorization"
              }
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }
            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
        statement {
          sqli_match_statement {
            field_to_match {
              single_header {
                name = "cookie"
              }
            }
            text_transformation {
              priority = 1
              type     = "URL_DECODE"
            }

            text_transformation {
              priority = 2
              type     = "HTML_ENTITY_DECODE"
            }
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "MetricForSqlInjectionRule"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    "Name"         = "pragma-modelo-de-crecimiento-pdn-waf",
    "environment"  = "pdn",
    "project-name" = "modelo-de-crecimiento",
    "owner"        = "Joseph-Rojas",
    "area"         = "cloud-ops",
    "provisioned"  = "terraform",
    "cost-center"  = "9904"
  }
}
