variable "app_port" {
  description = "port of the application"
  type = number
  default = 8080
}

variable "vpc_id" {
  description = "id of the vpc"
  type = string
}