region = "us-east-2"

main_vpc_cidr = "10.0.0.0/16"

vpc_dns_hostname = true

private_subnets = 2

public_subnets = 2

data_subnets = 0

ami_launch_template = "ami-05bfbece1ed5beb54"

instance_type = "t2.micro"

capacity = {
  desired_capacity = 2
  max_size         = 4
  min_size         = 2
}

sg_config = [{
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "TCP rule"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }]
  egress = [{
    description      = "Outbound rule"
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
  name = "pragma-mapa-crecimiento-pdn-security-group-launch-template"
  }
  ,
  {
    name = "pragma-mapa-crecimiento-pdn-security-group-load-balancer"

    ingress = [{
      from_port        = 80
      description      = "HTTP rule"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      to_port          = 80
    }]
    egress = [{
      description      = "Outbound rule"
      cidr_blocks      = ["0.0.0.0/0"]
      from_port        = 0
      protocol         = "-1"
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }]
}]

create_association = true
