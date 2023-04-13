variable "vpc" {
  type = string
}

variable "config" {
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
