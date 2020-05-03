resource "aws_iam_policy" "policy" {
  name = "${var.name}"

  policy = "${data.template_file.policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_s3" {
  count = "${length(var.role_names)}"

  policy_arn = "${aws_iam_policy.policy.arn}"
  role       = "${var.role_names[count.index]}"
}

data "template_file" "policy" {
  template = "${file("${path.module}/../templates/policy_${var.name}.json")}"

  vars = "${var.vars}"
}
