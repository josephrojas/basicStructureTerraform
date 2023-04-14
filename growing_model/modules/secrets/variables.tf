variable "secrets" {
    type = list(object({
        name = string
        secret = map(string)
    }))
}