# create subnet

resource "aws_subnet" "main" {
  #vpc_id = "${aws_vpc.main.id}"
  vpc_id = "${var.vpc_id_var}"
  cidr_block = "${var.subnet_cidr_var}"
}
