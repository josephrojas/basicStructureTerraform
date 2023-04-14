output "vpc_id" {
  value = aws_vpc.vpc_services.id
}

output "private_subnet" {
    value = aws_subnet.private_subnets.*.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "subnet_group" {
  value = aws_db_subnet_group.subnet_group_data[0].id
}

output "data_subnets" {
  value = aws_subnet.data_subnets.*.id
}