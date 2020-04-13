resource "aws_instance" "kube_admin" {
  ami = "ami-0be057a22c63962cb"
  instance_type = "t2.medium"
  subnet_id     = "subnet-05d8cc6487568b447"

  key_name = "${aws_key_pair.ssh_key.id}" //ATTACH KEY-PAIR

  security_groups = ["${aws_security_group.kube_sg.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  tags = {
    Name = "Kube_Admin"
  }
}

resource "aws_instance" "kube_node_1" {
  ami           = "ami-0be057a22c63962cb"
  instance_type = "t2.micro"
  subnet_id     = "subnet-05d8cc6487568b447"

  key_name = "${aws_key_pair.ssh_key.id}"

  security_groups = ["${aws_security_group.kube_sg.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  tags = {
    Name = "Kube_Node_1"
  }
}
