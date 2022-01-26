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
module "my_vpc" {
  source = "../vpc"
  vpc_cidr = "172.22.0.0/16"
  vpc_id = "${module.my_vpc.vpc_id}"
  subnet_cidr = "172.22.1.0/24"
}


module "my_ec2" {
    source = "../ec2"
    ec2_count = 1
    instance_type = "t3.medium"
    ami_id = "ami-0f2e255ec956ade7f"
    subnet_id = "${module.my_vpc.subnet_id}"

}
