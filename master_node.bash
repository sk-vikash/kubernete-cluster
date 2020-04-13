#! /bin/bash

echo "######### Initialise the kubernetes master ....."
private_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4);
echo $private_ip;
sudo kubeadm init --pod-network-cidr=10.244.0.0/16;
# sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$private_ip;

echo "######### Perform post initialisation task on master ....."

mkdir -p $HOME/.kube;
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;
sudo chown $(id -u):$(id -g) $HOME/.kube/config;

echo "######### Install a Pod network add-on with the following command on the control-plane node ....."
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml;

# kubeadm join 10.0.1.235:6443 --token 1axuvb.nf72mxdz7sdswsrq --discovery-token-ca-cert-hash sha256:8084799ce5a0d08bda180b904645b6160ec5f904c398e615b476aeff3a93a2c3
