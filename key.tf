resource "aws_key_pair" "ssh_key" {
  key_name   = "test-kube"
  public_key = "${file("${path.module}/test-kube.pub")}"
}
