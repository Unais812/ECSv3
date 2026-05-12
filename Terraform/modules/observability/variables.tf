variable "instance_type" {
  description = "instance type for the ec2 instance"
  type = string
  default = "t3.small"
}

variable "vpc_cidr" {
  description = "cidr of vpc"
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_id" {
  description = "id of vpc"
  type = string
}

variable "public_subnet_id" {
  description = "public subnet ids for nat"
  type = string
}

variable "igw_id" {
  description = "id of igw"
  type = string
}

variable "public_cidr" {
  description = "cidr for public access"
  type = string
  default = "0.0.0.0/0"
}

variable "ecs_sg" {
  description = "id of the ecs sg allowing ecs tasks to accept traffic from instance"
  type = string
}
