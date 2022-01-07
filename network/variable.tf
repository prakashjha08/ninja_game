variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "region" {
  type = string
}

variable "tags" {
  default = {}
}