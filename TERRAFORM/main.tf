terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}

module "vpc" {
source = "./vpc"
}

#module "sg" {
#source = "./sg"
#vpc_id = ["${module.vpc.vpc_internal_id}"]
#}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAWAGKOJB7GLWI2JHJ"
  secret_key = "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"
}


