provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source        = "github.com/ericdahl/tf-vpc"
  admin_ip_cidr = "${var.admin_cidr}"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = [137112412989]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "instance" {
  ami           = "${data.aws_ami.amazon_linux_2.image_id}"
  instance_type = "t2.small"
  subnet_id     = "${module.vpc.subnet_private1}"

  vpc_security_group_ids = [
    "${module.vpc.sg_allow_egress}",
  ]

  key_name = "${var.key_name}"

  iam_instance_profile = "${aws_iam_instance_profile.ec2_session_manager.name}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_s3_bucket" "ssm_logs" {
  bucket = "${replace(var.name, "_", "-")}"
}
