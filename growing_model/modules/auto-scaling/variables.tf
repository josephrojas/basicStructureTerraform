variable "ami_launch_template" {
  type = string
  default = "ami-05bfbece1ed5beb54"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "security_groups" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "capacity" {
  type = object({
    desired_capacity = number
    max_size = number
    min_size = number
  })
}

variable "subnets" {
  type = list(string)

}

variable "target_group" {
  type = string
}

variable "create_association" {
  type = number
}