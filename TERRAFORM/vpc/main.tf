# create VPC
resource "aws_vpc" "prd-vpc" {
  cidr_block = "172.20.0.0/16"
    tags = {
    Name = "Prod-VPC"
}
}


variable "vpc_cidr_var" {
    default = "172.20.0.0/16"
}

variable "vpc_id_var" {}

variable "subnet_cidr_var" {
  default = "172.20.1.0/24"
}