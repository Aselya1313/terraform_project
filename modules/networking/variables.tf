variable "vpc_cidr" {
    default = []
}

variable "name" {
    default = "project"
}

variable "public_cidrs" {
    default = []
}

variable "private_cidrs" {
    default = []
}

variable "cidr_block" {
  description = "CIDR блок для VPC"
}
