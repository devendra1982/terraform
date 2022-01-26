terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}
provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAWAGKOJB7GLWI2JHJ"
  secret_key = "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"
}

#################   VPC Here
module "my_vpc" {
  source = "../vpc"
  vpc_cidr_var = "172.23.0.0/16"
  vpc_id_var = ""
}

#############  Subnet here
module "my_subnet" {
	source = "../subnetgroup"
  vpc_id_var = "${module.my_vpc.vpc_id_output}"
	subnet_cidr_var = "172.23.1.0/24"	
}

############# EC2 Here
module "my_ec2" {
    source = "../ec2"
    ec2_count_var = 1
    instance_type_var = "t3.medium"
    ami_id_var = "ami-0f2e255ec956ade7f"
    subnet_id_var = "${module.my_subnet.subnet_id_output}"

}

output vpc_id {
#  value = "${module.my_vpc.vpc_id_output}"
  value = "${module.my_vpc.aws_vpc.main.id}"

}



output "instance-name" {
  value = "${module.my_ec2.}"
}