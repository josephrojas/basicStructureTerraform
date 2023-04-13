resource "aws_security_group" "security_group" {
  count  = length(var.config)
  vpc_id = var.vpc
  name   = var.config[count.index].name

  ingress = var.config[count.index].ingress
  egress  = var.config[count.index].egress


  tags = {
    "Name"         = var.config[count.index].name,
    "environment"  = "pdn",
    "project-name" = "modelo-de-crecimiento",
    "owner"        = "Joseph-Rojas",
    "area"         = "cloud-ops",
    "provisioned"  = "terraform",
    "cost-center"  = "9904"
  }

}
