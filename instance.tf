resource "aws_instance" "kube_admin" {
  ami = "ami-0be057a22c63962cb"
  instance_type = "t2.medium"
  subnet_id = "${data.aws_subnet.subnet_2a.id}"


  key_name = "${aws_key_pair.ssh_key.id}"

  security_groups = ["${aws_security_group.kube_sg.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  tags = {
    Name = "Kube_Master"
  }
}

resource "aws_instance" "kube_node_1" {
  ami           = "ami-0be057a22c63962cb"
  instance_type = "t2.medium"
  subnet_id = "${data.aws_subnet.subnet_2a.id}"

  key_name = "${aws_key_pair.ssh_key.id}"

  security_groups = ["${aws_security_group.kube_sg.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  tags = {
    Name = "Kube_Worker_1"
  }
}
