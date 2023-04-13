output "dns" {
  description = "ALB endpoint"
  value = aws_lb.alb_workshop.dns_name
}