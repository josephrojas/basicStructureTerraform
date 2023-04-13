output "security_group_id" {
  value = [for sg in aws_security_group.security_group : sg.id]
}