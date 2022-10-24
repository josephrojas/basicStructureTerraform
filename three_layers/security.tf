#Creation of security groups
resource "aws_security_group" "lamp-ingress-sg" {
  vpc_id =  aws_vpc.lamp_lab.id
  name = "lamp-ingress-sg"

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

  tags = {
    Name = "lamp-ingress-sg"
  }
}


#bastion security group
resource "aws_security_group" "lamp-bastion-host" {
  vpc_id =  aws_vpc.lamp_lab.id
  name = "lamp-bastion-host"

  ingress =  [{
    from_port = 22
    description = "TCP rule"
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
    to_port = 22
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

  tags = {
    Name = "lamp-bastion-host"
  }
}


resource "aws_security_group" "lamp-app-sg" {
  vpc_id =  aws_vpc.lamp_lab.id
  name = "lamp-app-sg"

  ingress =  [
  {
    from_port = 22
    protocol = "tcp"
    description = "TCP rule"
    cidr_blocks = []
    to_port = 22
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [aws_security_group.lamp-bastion-host.id]
    self = false
  },
  {
    from_port = 80
    description = "HTTP rule"
    protocol = "tcp"
    cidr_blocks = []
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [aws_security_group.lamp-ingress-sg.id]
    self = false
    to_port = 80
  }  ]
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

  tags = {
    Name = "lamp-app-sg"
  }
}
#Security group of RDS
resource "aws_security_group" "lamp-rds-sg" {
  vpc_id =  aws_vpc.lamp_lab.id
  name = "lamp-rds-sg"

  ingress =  [
  {
    from_port = 3306
    protocol = "tcp"
    description = "TCP rule"
    cidr_blocks = []
    to_port = 3306
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [aws_security_group.lamp-app-sg.id]
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

  tags = {
    Name = "lamp-rds-sg"
  }
}

#Creation of keypair

resource "tls_private_key" "wkp" {
  algorithm = "RSA"
}

resource "aws_key_pair" "workshop_key_pair" {
    key_name = "lamp_key_pair"
    public_key = tls_private_key.wkp.public_key_openssh
    tags = {
        Name = "lamp_key_pair"
    }
}

resource "local_file" "myKey" {
  content = tls_private_key.wkp.private_key_pem
  filename = "lamp_key_pair.pem"
}

#Creation of secret 
resource "aws_secretsmanager_secret" "lamp_access_key" {
  name = "lamp_access_key"
}
resource "aws_secretsmanager_secret_version" "access" {
  secret_id = aws_secretsmanager_secret.lamp_access_key.id
  secret_string = jsonencode(var.credentials)
}

#creation of KMS

resource "aws_kms_key" "bd_key" {
  description = "kms key for BD"
  tags = {
    Name = "joseph_rojas_kms_db"
  }
}