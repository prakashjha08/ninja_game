variable "team_name" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "alb_subnet_ids" {
  type = list(any)
}

variable "private_subnet_id" {
  type = string
}

variable "nat_gw_id" {
  type = string
}

variable "region" {
  type = string
}
