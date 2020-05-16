variable "name" {
}

variable "role_names" {
  default = []
}

variable "vars" {
  type    = map(string)
  default = {}
}

