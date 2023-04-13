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

variable "create_association" {
  type = bool
}
