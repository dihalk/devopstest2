variable "lb_name" {
  type    = string
  default = "Django-lb"
}

variable "lb_internal" {
  type    = bool
  default = false
}

variable "lb_type" {
  type    = string
  default = "application"
}

variable "server_name" {
  type    = string
  default = "Django"
}

variable "lb_tg_name" {
  type    = string
  default = "Django-lb-tg"
}

variable "lb_tg_port" {
  type    = number
  default = 8000
}

variable "lb_tg_type" {
  type    = string
  default = "instance"
}

variable "lb_protocol" {
  type    = string
  default = "HTTP"
}

variable "health_check_enabled" {
  type    = bool
  default = true
}

variable "health_check_interval" {
  type    = number
  default = 10
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_port" {
  type    = number
  default = 8000
}

variable "lb_matcher" {
  type    = string
  default = "200"
}

variable "lb_listner_port" {
  type    = string
  default = "80"
}

variable "lb_tg_group_att_port" {
  type    = number
  default = 8000
}