variable "lamp_vpc_CIDR" {
  type = string
  default = "10.0.0.0/16"
  
}

variable "credentials" {
  type = object({
    username = string
    password = string
  })
}

