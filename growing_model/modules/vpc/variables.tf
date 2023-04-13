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

