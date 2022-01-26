# create VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_var}"
    tags = {
    Name = "Prod-VPC"
}
}

