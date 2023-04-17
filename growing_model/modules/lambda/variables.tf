variable "roles" {
    type = list(string)
}

variable "function_conf" {
    type = list(object({
        code_name = string
        function_name = string
        runtime = string
    }))
}

variable "source_arn" {
    type = string
}