resource "aws_instance" "web" {
   count         = "${var.ec2_count_var}"
   ami           = "${var.ami_id_var}"
   instance_type = "${var.instance_type_var}"
   subnet_id = "${var.subnet_id_var}"
   #availability_zone = "ap-south-1"

 tags = {
     Name = "Newserver1"
     infra = "dev"
 }
}