#Creation of security groups
resource "aws_security_group" "joseph_rojas_public_security_group" {
  vpc_id =  aws_vpc.main_vpc.id
  name = "sg_group_public_ec2"

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
  },
  {
    from_port = 22
    protocol = "tcp"
    description = "TCP rule"
    cidr_blocks = [ "0.0.0.0/0" ]
    to_port = 22
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
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
    Name = "public_SG_ec2"
  }
}

resource "aws_security_group" "joseph_rojas_private_security_group" {
  vpc_id =  aws_vpc.main_vpc.id
  name = "sg_group_private_ec2"

  ingress =  [
  {
    from_port = 22
    protocol = "tcp"
    description = "TCP rule"
    cidr_blocks = []
    to_port = 22
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [aws_security_group.joseph_rojas_public_security_group.id]
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
    Name = "private_SG_ec2"
  }
}

resource "aws_security_group" "joseph_rojas_rds_security_group" {
  vpc_id =  aws_vpc.main_vpc.id
  name = "sg_group_access_rds"

  ingress =  [
  {
    from_port = 3306
    protocol = "tcp"
    description = "TCP rule"
    cidr_blocks = []
    to_port = 3306
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [aws_security_group.joseph_rojas_private_security_group.id]
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
    Name = "private_SG_rds"
  }
}

#Creation of keypair

resource "tls_private_key" "wkp" {
  algorithm = "RSA"
}

resource "aws_key_pair" "workshop_key_pair" {
    key_name = "workshop_key_pair_ec2"
    public_key = tls_private_key.wkp.public_key_openssh
    tags = {
        Name = "key_pair_joseph_rojas_ec2"
    }
}

resource "local_file" "myKey" {
  content = tls_private_key.wkp.private_key_pem
  filename = "my_key.pem"
}

#Creation of secret 
resource "aws_secretsmanager_secret" "secret_master_bd_final" {
  name = "master_access_key"
}
resource "aws_secretsmanager_secret_version" "access" {
  secret_id = aws_secretsmanager_secret.secret_master_bd_final.id
  secret_string = jsonencode(var.credentials)
}

#creation of KMS

resource "aws_kms_key" "bd_key" {
  description = "kms key for BD"
  tags = {
    Name = "joseph_rojas_kms_db"

  }
}