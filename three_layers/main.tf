 provider "aws" {
   region = "us-east-2"
 }
#creation of DB
 resource "aws_db_instance" "lamp-mysql" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "8.0.28"
    db_subnet_group_name = aws_db_subnet_group.lamp-rds-group.id
    instance_class = "db.t3.micro"
    username = jsondecode(aws_secretsmanager_secret_version.access.secret_string)["username"]
    password = jsondecode(aws_secretsmanager_secret_version.access.secret_string)["password"]
    db_name = "master"
    kms_key_id = aws_kms_key.bd_key.arn
    publicly_accessible = false
    apply_immediately = true
    skip_final_snapshot = true  
    vpc_security_group_ids = [aws_security_group.lamp-rds-sg.id]   
    storage_encrypted = true   
    port = 3306
    maintenance_window = "Mon:00:00-Mon:03:00"
    backup_window = "03:00-06:00"
    backup_retention_period = 1
    tags = {
      Name = "lamp-mysql"
    }
 }