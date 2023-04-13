provider "aws" {
  region = var.region
}

resource "tls_private_key" "wkp" {
  algorithm = "RSA"
}

resource "aws_key_pair" "workshop_key_pair" {
  key_name   = "workshop_key_pair_ec2"
  public_key = tls_private_key.wkp.public_key_openssh
  tags = {
    "Name"         = "pragma-modelo-crecimiento-key-pair",
    "environment"  = "pdn",
    "project-name" = "modelo-de-crecimiento",
    "owner"        = "Joseph-Rojas",
    "area"         = "cloud-ops",
    "provisioned"  = "terraform",
    "cost-center"  = "9904"
  }
}

resource "local_file" "myKey" {
  content  = tls_private_key.wkp.private_key_pem
  filename = "my_key.pem"
}


#########################################
#---------------MODULES-----------------#
#########################################

module "vpc" {
  source           = "./modules/vpc"
  main_vpc_cidr    = var.main_vpc_cidr
  vpc_dns_hostname = var.vpc_dns_hostname
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  data_subnets     = var.data_subnets
}
module "security_group" {
  source = "./modules/security-group"
  vpc    = module.vpc.vpc_id
  config = var.sg_config
}

module "alb" {
  source = "./modules/alb"
  vpc = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.security_group.security_group_id[1]]
}

module "autoscaling" {
  depends_on = [
    module.alb
  ]
  source              = "./modules/auto-scaling"
  ami_launch_template = var.ami_launch_template
  instance_type       = var.instance_type
  security_groups     = [module.security_group.security_group_id[0]]
  key_name            = aws_key_pair.workshop_key_pair.key_name
  capacity            = var.capacity
  subnets             = module.vpc.private_subnet
  create_association = var.create_association
  target_group = module.alb.target_group

}





