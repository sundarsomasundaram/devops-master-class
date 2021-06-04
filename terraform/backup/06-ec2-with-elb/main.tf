provider "aws" {
  region = "us-east-2"
  //version = "~> 2.46" (No longer necessary)
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"  
  enable_dns_support = "1"
  enable_dns_hostnames = "1"
 tags = {
      Name = "myfirstvpc"      # Name of your vpc
          }

}

resource "aws_subnet" "first" {
  availability_zone = "us-west-2a"
  cidr_block = "192.168.1.0/24"
  map_public_ip_on_launch = "1"
  vpc_id = "${aws_vpc.main.id}"  #from the vpc resource aws_vpc main
  tags = {
      Name = "myfirstsubnet"
          }
}

resource "aws_instance" "firstec2" {
  ami = "ami-0ba60995c1589da9d"
  instance_type = "t2.micro"
  key_name = " "    #This can be downloaded from your AWS Account 
  subnet_id = "${aws_subnet.first.id}"    # from the subnet resource aws_subnet first
  tags = {
      Name = "knode"
          }
  user_data = file("./install.sh")
}


resource "aws_internet_gateway" "internet" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
      Name = "myinternetgateway"
          }
}

resource "aws_route" "internet" {
  route_table_id            = "${aws_vpc.main.default_route_table_id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet.id}"
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.first.id}"
  route_table_id = "${aws_vpc.main.default_route_table_id}"
}
resource "aws_default_security_group" "default_myfirst" {
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.main.id}"
  tags = {
      Name = "myfirstsecuritygroup"
          }
}
resource "aws_network_interface" "first" {
  subnet_id = "${aws_subnet.first.id}"
  tags = {
      Name = "mynetworkinterface"
          }
}
resource "aws_network_interface_attachment" "connect" {
  instance_id          = "${aws_instance.firstec2.id}"
  network_interface_id = "${aws_network_interface.first.id}"
  device_index         = 1
}

output "IPs" {
  value = "kmaster -  ${aws_instance.firstec2.public_ip}"
}


