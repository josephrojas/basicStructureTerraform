output "dbidentifier" {
    value = aws_db_instance.rds.*.identifier
}