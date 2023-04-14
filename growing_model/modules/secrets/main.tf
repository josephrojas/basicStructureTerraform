resource "aws_secretsmanager_secret" "secret" {
  count = length(var.secrets)
  name  = var.secrets[count.index].name
}
resource "aws_secretsmanager_secret_version" "secret_value" {
  count         = length(var.secrets)
  secret_id     = aws_secretsmanager_secret.secret[count.index].id
  secret_string = jsonencode(var.secrets[count.index].secret)
}
