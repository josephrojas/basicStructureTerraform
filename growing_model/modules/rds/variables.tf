variable "rds_config" {
  type = list(object({
    allocated_storage = number
    engine            = string
    engine_version    = string
    instance_class    = string
    db_name           = string
    port              = number
    multi_az          = bool
  }))
}

variable "db_subnet_group_name" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "credentials" {
  type = list(object({
    username = string
    password = string
  }))
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "proxy_conf" {
  type = list(object({
    name                = string
    engine_family       = string
    idle_client_timeout = number
    require_tls        = bool


    auth = object({
      auth_scheme               = string
      client_password_auth_type = string
      description               = string
      secret_arn                = string
    })
  }))
}

variable "arn_proxy" {
  type = string
}

variable "proxy_security_group_ids" {
  type = list(string)

}

variable "vpc_subnet_ids" {
  type = list(string)
}
