variable "credentials" {
  default = {
    username = "main"
    password = "lab-rds-master"
  }
  type = map(string)
  sensitive = true
}
