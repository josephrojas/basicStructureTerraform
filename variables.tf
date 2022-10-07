variable "credentials" {
  default = {
    username = "main"
    password = "lab-rds-master"
  }
  type = map(string)
  sensitive = true
}

variable "publicSubnetEC2" {
  type = number
  default = 1
}

variable "privateSubnetEC2" {
  type = number
  default = 2
}

variable "main_vpc_cidr" {
  type = string
  default = "10.1.0.0/16" 
}