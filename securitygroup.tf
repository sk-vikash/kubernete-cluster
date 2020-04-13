resource "aws_security_group" "kube_sg" {
  name   = "Kube-sg"
  vpc_id = "vpc-0c42eaa6b0fb854da"

  tags {
    Name  = "kube-sg"
    Owner = "Rdf"
  }
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kube_sg.id}"
}

resource "aws_security_group_rule" "all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = "${aws_security_group.kube_sg.id}"
}

resource "aws_security_group_rule" "all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kube_sg.id}"
}
