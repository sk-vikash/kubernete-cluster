output "instance_kube_admin_public_ip" {
  value = "${aws_instance.kube_admin.public_ip}"
}

output "instance_kube_node_1_public_ip" {
  value = "${aws_instance.kube_node_1.public_ip}"
}

# 
# output "instance_kube_node_2_public_ip" {
#   value = "${aws_instance.kube_node_2.public_ip}"
# }

