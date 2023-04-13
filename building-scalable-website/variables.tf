variable "main_vpc_cidr" {
  type = string
  default = "10.1.0.0/16" 
}

variable "vpc_dns_hostname" {
    type = bool
    default = true
}

variable "private_subnets" {
  type = number
  default = 2
}

variable "public_subnets" {
  type = number
  default = 2
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "dashboard_name" {
  type = string
  default = "pragma-mapa-crecimiento-pdn-dasboard"
}