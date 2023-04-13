#########################################
#------------SECURITY-GROUP-------------#
#########################################
resource "aws_security_group" "security_group_load_balancer" {
  vpc_id =  aws_vpc.workshop_vpc.id
  name = "pragma-mapa-crecimiento-pdn-security-group-load-balancer"

  ingress =  [{
    from_port = 80
    description = "HTTP rule"
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
    to_port = 80
  }]
  egress = [ {
    description = "Outbound rule"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  } ]

  tags_all = {
     "Name" = "pragma-mapa-crecimiento-pdn-security-group-load-balancer",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
    }
}


resource "aws_security_group" "security_group_template" {
  vpc_id =  aws_vpc.workshop_vpc.id
  name = "pragma-mapa-crecimiento-pdn-security-group-launch-template"

  ingress =  [
  {
    from_port = 80
    protocol = "tcp"
    description = "TCP rule"
    cidr_blocks = []
    to_port = 80
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [aws_security_group.security_group_load_balancer.id]
    self = false
  } ]
  egress = [ {
    description = "Outbound rule"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  } ]

  tags_all = {
     "Name" = "pragma-mapa-crecimiento-pdn-security-group-launch-template",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
    }
}


#########################################
#----------------KEY-PAIR---------------#
#########################################

resource "tls_private_key" "private_key_pair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "workshop_key_pair" {
    key_name = "pragma-mapa-crecimiento-pdn-key-pair"
    public_key = tls_private_key.private_key_pair.public_key_openssh
    tags_all = {
     "Name" = "pragma-mapa-crecimiento-pdn-key-pair",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
    }
}

resource "local_file" "myKey" {
  content = tls_private_key.private_key_pair.private_key_pem
  filename = "my_key.pem"
}