variable "iam_user_name_prefix" {
  type    = string #any, number, bool, list, map, set, object, tuple
  default = "my_iam_user"
}

provider "aws" {
  region  = "us-east-1"
  //version = "~> 2.46" (No longer necessary)
}

resource "aws_iam_user" "devops_usr_001" {
  count = 2
  name  = "${var.iam_user_name_prefix}_${count.index}"
}