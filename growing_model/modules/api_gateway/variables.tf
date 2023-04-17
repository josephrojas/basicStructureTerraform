variable "api_name" {
    type = string
}

variable "resource" {
    type = list(object({
        path_part = string
        http_method = string
    }))
}

variable "uri" {
    type = list(string)
}