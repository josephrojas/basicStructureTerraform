variable "policies" {
  type = list(object({
    name        = string
    description = string
  }))
}

variable "document" {
  type = object({
    actions   = list(string)
    resources = list(string)
    effect    = string
  })
}
