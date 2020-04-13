data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars = {
    "test" = "test"
  }
}

data "aws_subnet" "subnet_2a" {
  filter {
    name   = "tag:Name"
    values = ["main-public-1"]
  }
}

data "aws_subnet" "subnet_2b" {
  filter {
    name   = "tag:Name"
    values = ["main-public-2"]
  }
}