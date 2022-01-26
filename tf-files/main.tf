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

# create VPC
resource "aws_vpc" "prd-vpc" {
  cidr_block = "172.20.0.0/16"
    tags = {
    Name = "Prod-VPC"
}
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.prd-vpc.id  
}

# route table
resource "aws_route_table" "prd-route-table" {
  vpc_id = aws_vpc.prd-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "route_table"
  }
}

# create a subnet

resource "aws_subnet" "web" {
  vpc_id     = aws_vpc.prd-vpc.id
  cidr_block = "172.20.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Web"
  }
}
# another subnet
resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.prd-vpc.id
  cidr_block = "172.20.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "db"
  }
}

# subnet with route table association

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.prd-route-table.id
}

# create security group

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow 80 443 and 22 traffic"
  vpc_id      = aws_vpc.prd-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Non-TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}


# network interface

resource "aws_network_interface" "web1" {
  subnet_id       = aws_subnet.web.id
  private_ips     = ["172.20.1.21"]
  security_groups = [aws_security_group.web.id]

}


# allocation of public ip

resource "aws_eip" "web" {
  vpc = true
  network_interface = aws_network_interface.web1.id
  associate_with_private_ip = "172.20.1.21"
  depends_on =  [aws_internet_gateway.igw]
    tags = {
    "Name" = "Webserverpublicip"
  }
}

resource "aws_instance" "web" {
   ami           = "ami-08ee6644906ff4d6c"
   instance_type = "t2.micro"
   availability_zone = "ap-south-1a"
   key_name = "${aws_key_pair.deven.id}"
   network_interface  {
       device_index = 0
       network_interface_id = aws_network_interface.web1.id
   }
 
 tags = {
     Name = "Newserver1"
     infra = "dev"
 }
    user_data = <<-EOF
                #!/bin/sh
                sudo apt-get update
                sudo apt-get install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo hello > /var/www/html/index.html'
                EOF
}

/* resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web.id
} */

resource "aws_key_pair" "deven" {
  key_name   = "deven"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzwWCvjvwT7sRdOpuRCBaMy+myaM8ME+HKhFWILWNtnFqxo7/NB8Mh8syxVUgPsmwZl6YxHCubCWPr/GszPYpkUD7SVKbHhgftWdIKLMTCPZOKPHWKzQSCVJrZ1hjsIkzIs1ctiJqDm5dDU9LOg3R1o9XvLzmTLo/C8DRUipCBFnYNIjo4K9B+aDDexIJlvvphNG7Ukx1aXE2KvJL07git1Bp+JJpBs19Qj+dVjrPWiyC7TXDKZ+qYHhQIT34M8rr0nloH6InToy2ppTnHll57YhrXzBQ+ifMeaI+M19UgkmzMxQIVA/TpjbZxLH+SA6d6P2DqADySA/sV6OBqDm7Yw== deven@deven-laptop"
}

output "server-public-ip" {
#  value = aws_eip.web.public_ip
	value = aws_subnet.db.cidr_block
}
