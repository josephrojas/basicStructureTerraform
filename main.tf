 provider "aws" {
   region = "us-east-2"
 }

# Select the type of instance for usability 

# Creation of instances
 resource "aws_instance" "public_instance"{
    ami = "ami-0568773882d492fc8"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.publicsubnets.id
    key_name = aws_key_pair.workshop_key_pair.key_name
    vpc_security_group_ids = [ aws_security_group.joseph_rojas_public_security_group.id ]
    associate_public_ip_address = true
    tags = {
        Name = "public_instance"
    }
    user_data = "${file("httpd.sh")}"
 }

 resource "aws_instance" "private_instance" {
    ami = "ami-0568773882d492fc8"
    instance_type = "t2.micro"
    depends_on = [
      aws_db_instance.rds_joseph
    ]
    subnet_id = aws_subnet.privatesubnets.id
    key_name = aws_key_pair.workshop_key_pair.key_name
    vpc_security_group_ids = [ aws_security_group.joseph_rojas_private_security_group.id ]
    associate_public_ip_address = false
    tags = {
        Name = "private_instance"
    }
    user_data = "${file("httpd.sh")}"
 }


#creation of DB
 resource "aws_db_instance" "rds_joseph" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "mysql"
    engine_version = "8.0.28"
    db_subnet_group_name = aws_db_subnet_group.subnet_group_joseph.id
    instance_class = "db.t3.micro"
    username = jsondecode(aws_secretsmanager_secret_version.access.secret_string)["username"]
    password = jsondecode(aws_secretsmanager_secret_version.access.secret_string)["password"]
    db_name = "master"
    kms_key_id = aws_kms_key.bd_key.arn
    publicly_accessible = false
    apply_immediately = true
    skip_final_snapshot = true  
    vpc_security_group_ids = [aws_security_group.joseph_rojas_rds_security_group.id]   
    storage_encrypted = true   
    port = 3306
    maintenance_window = "Mon:00:00-Mon:03:00"
    backup_window = "03:00-06:00"
    backup_retention_period = 1
    tags = {
      Name = "BD workshop"
    }
 }

 #creation of DB replica
 resource "aws_db_instance" "rds_read_replica" {
    allocated_storage = 20
    storage_type = "gp2"
    instance_class = "db.t3.micro"
    replicate_source_db = aws_db_instance.rds_joseph.id
    publicly_accessible = false
    apply_immediately = true
    kms_key_id = aws_kms_key.bd_key.arn
    skip_final_snapshot = true  
    vpc_security_group_ids = [aws_security_group.joseph_rojas_rds_security_group.id]      
    storage_encrypted = true
    port = 3306
    backup_retention_period = 0
    tags = {
      Name = "BD replica"
    }
 }