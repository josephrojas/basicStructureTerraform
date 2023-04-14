resource "aws_db_instance" "rds" {
  count                   = length(var.rds_config)
  allocated_storage       = var.rds_config[count.index].allocated_storage
  storage_type            = "gp2"
  engine                  = var.rds_config[count.index].engine
  engine_version          = var.rds_config[count.index].engine_version
  db_subnet_group_name    = var.db_subnet_group_name
  instance_class          = var.rds_config[count.index].instance_class
  username                = var.credentials[count.index].username
  password                = var.credentials[count.index].password
  db_name                 = var.rds_config[count.index].db_name
  kms_key_id              = var.kms_key_id
  publicly_accessible     = false
  apply_immediately       = true
  skip_final_snapshot     = true
  vpc_security_group_ids  = var.vpc_security_group_ids
  storage_encrypted       = true
  port                    = var.rds_config[count.index].port
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 1
  multi_az                = var.rds_config[count.index].multi_az
  tags = {
    "Name"         = "pragma-modelo-de-crecimiento-pdn-rds",
    "environment"  = "pdn",
    "project-name" = "modelo-de-crecimiento",
    "owner"        = "Joseph-Rojas",
    "area"         = "cloud-ops",
    "provisioned"  = "terraform",
    "cost-center"  = "9904"
  }
}

resource "aws_db_proxy" "proxy" {
  count                  = length(var.proxy_conf)
  name                   = var.proxy_conf[count.index].name
  engine_family          = var.proxy_conf[count.index].engine_family
  idle_client_timeout    = var.proxy_conf[count.index].idle_client_timeout
  require_tls            = var.proxy_conf[count.index].require_tls
  role_arn               = var.arn_proxy
  vpc_security_group_ids = var.vpc_security_group_ids
  vpc_subnet_ids         = var.vpc_subnet_ids
  auth {
    auth_scheme               = var.proxy_conf[count.index].auth.auth_scheme
    client_password_auth_type = var.proxy_conf[count.index].auth.client_password_auth_type
    description               = var.proxy_conf[count.index].auth.description
    secret_arn                = var.proxy_conf[count.index].auth.secret_arn
  }
}
