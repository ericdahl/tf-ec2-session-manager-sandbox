output "aws_instance.tf_efs_sandbox.public_ip" {
  value = "${aws_instance.instance.public_ip}"
}


output "aws_instance.tf_efs_sandbox.id" {
  value = "${aws_instance.instance.id}"
}
