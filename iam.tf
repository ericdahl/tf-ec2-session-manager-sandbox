resource "aws_iam_role" "instance_profile" {
  name = "${var.name}-ec2"

  assume_role_policy = data.template_file.assume_ec2.rendered

  tags = {
    Name = var.name
  }
}

resource "aws_iam_instance_profile" "ec2_session_manager" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.instance_profile.name
}

data "template_file" "assume_ec2" {
  template = file("${path.module}/templates/assume_ec2.json")
}

module "ssm_base" {
  source = "./policy/"

  name       = "ssm_base"
  role_names = [aws_iam_role.instance_profile.name]
}

module "ssm_s3" {
  source = "./policy/"

  name       = "ssm_s3"
  role_names = [aws_iam_role.instance_profile.name]

  vars = {
    s3_bucket_log_resource = "${aws_s3_bucket.ssm_logs.arn}/*"
  }
}

