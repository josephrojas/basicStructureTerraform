variable "region" {
    type = string
}

variable "main_vpc_cidr" {
  type = string
}

variable "vpc_dns_hostname" {
    type = bool
}

variable "private_subnets" {
  type = number
}

variable "public_subnets" {
  type = number
}


variable "data_subnets" {
    type = number
}

variable "ami_launch_template" {
  type = string
}

variable "instance_type" {
    type = string
}


variable "capacity" {
  type = object({
    desired_capacity = number
    max_size = number
    min_size = number
  })
}

variable "create_association" {
  type = number
}

variable "sg_config" {
  type = list(object({
    name = string
    ingress = list(object({
      from_port        = number
      protocol         = string
      description      = string
      cidr_blocks      = list(string)
      to_port          = number
      ipv6_cidr_blocks = list(string)
      prefix_list_ids  = list(string)
      security_groups  = list(string)
      self             = bool
    }))
    egress = list(object({
      description      = string
      cidr_blocks      = list(string)
      from_port        = number
      protocol         = string
      to_port          = number
      ipv6_cidr_blocks = list(string)
      prefix_list_ids  = list(string)
      security_groups  = list(string)
      self             = bool
    }))
  }))
}



#########################################
#------------------S3-------------------#
#########################################
variable "bucket_name" {
  type    = string
}

variable "objects" {
  type = list(object({
    key = string
    source = string
    content_type = string
  }))
}


#########################################
#--------------CLOUDFRONT---------------#
#########################################

variable "cloudfront_origin" {
    type = string
}

#########################################
#-------------------WAF-----------------#
#########################################


variable "acl_name" {
    type = string
}

variable "scope" {
    type = string
}


#########################################
#-------------------RDS-----------------#
#########################################
variable "rds_config" {
    type = list(object({
        allocated_storage = number
        engine = string
        engine_version = string
        instance_class = string
        db_name = string
        port = number
        multi_az = bool
    }))
}


variable "credentials" {
    type = list(object({
        username = string
        password = string
    }))
    sensitive = true
}

variable "proxy_conf" {
  type = list(object({
    name                   = string
    engine_family          = string
    idle_client_timeout    = number
    require_tls           = bool
    auth = object({
        auth_scheme = string 
        client_password_auth_type = string
        description = string 
        secret_arn = string 
    })
  }))
}


#########################################
#-------------SECRETS-MANAGER-----------#
#########################################

variable "secrets" {
    type = list(object({
        name = string
        secret = map(string)
    }))
}

variable "dashboard_name" {
    type = string
}

#########################################
#-------------------IAM-----------------#
#########################################

variable "policies" {
    type = list(object({
        name = string
        description = string
    }))
}

variable "document" {
  type = object({
    actions   = list(string)
    resources = list(string)
    effect    = string
  })
}

#########################################
#----------------LAMBDA-----------------#
#########################################


variable "function_conf" {
    type = list(object({
        code_name = string
        function_name = string
        runtime = string
    }))
}