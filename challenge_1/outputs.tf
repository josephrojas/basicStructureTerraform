output "rds_endpoint" {
    description = "RDS endpoint"
    value = aws_db_instance.rds_joseph.endpoint
}

output "instance_id" {
    description = "ID of EC2 instance"
    value = aws_instance.public_instance.id
}

output "instance_public_ip" {
    description = "Public IP address  of the EC2 instance"
    value = "Private IP address of ${aws_instance.public_instance.tags["Name"]} : ${aws_instance.public_instance.private_ip}"
}


output "instance_private_ip" {
    description = "private IP address  of the EC2 instance"
    value = "Private IP address of ${aws_instance.public_instance.tags["Name"]} : ${aws_instance.private_instance.private_ip}"
}

output "instance_name" {
    description = "Name of EC2 instance"
    value = aws_instance.public_instance.key_name
}