resource "aws_instance" "web" {
   count         = "${var.ec2_count}"
   ami           = "${var.ami_id}"
   instance_type = "${var.instance_type}"
   subnet_id = "${var.subnet_id}"
   #availability_zone = "ap-south-1"

 tags = {
     Name = "Newserver1"
     infra = "dev"
 }
}