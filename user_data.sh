#! /bin/sh
# Purpose: Install Docker and K8 on Ubuntu
# Date: 18/02/2020 
# Modification: -
# Ref: https://www.edureka.co/blog/install-kubernetes-on-ubuntu


################################################
# Function to install DOCKER CE
################################################

install_docker() {
  echo "######### Update the apt package index ....."
  #apt-get update;

  echo "######### Install packages to allow apt to use a repository over HTTPS ....."
  apt-get update &&  apt-get install -y apt-transport-https ca-certificates curl gnupg-agent gnupg2 software-properties-common openssl-server;
  
  echo "######### Add Docker’s official GPG key ....."
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -;

  echo "######### Set up the stable repository ....."
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable";

  echo "######### Update the apt package index ....."
  apt-get update;

  echo "######### Install the version - 18.06.3 of Docker Engine Community and containerd ....."
  apt-get install -y containerd.io=1.2.10-3 docker-ce=5:19.03.4~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.4~3-0~ubuntu-$(lsb_release -cs);
}


################################################
# Function to do pre install Kubeadm
################################################
pre_install_kuberadm() {
  echo "######### Update the apt package index ....."
  apt-get update;
  
  apt-get install -y apt-transport-https curl;
  iptables -I INPUT 1 -j ACCEPT
  iptables -I OUTPUT 1 -j ACCEPT
  
  echo "######### Add Google's official GPG key ....."
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;
}


################################################
# Function to install Kubeadm
################################################
install_kuberadm() {
  echo "######### Update the apt package index ....."
  apt-get update;

  echo "######### Install kubelet, kubeadm & kubectl ....."
  apt-get install -y kubelet kubeadm kubectl;
  
  apt-get update;
}

################################################
# Function to start Kubeadm master node
################################################
start_kubeadmin_master() {
  echo "######### Initialise the kubernetes master ....."
  private_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4);
  echo $private_ip;
  #kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$private_ip;
  kubeadm init --pod-network-cidr=10.244.0.0/16;

  echo "######### Perform post initialisation task on master ....."
  
  mkdir -p $HOME/.kube;
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;
  chown $(id -u):$(id -g) $HOME/.kube/config;

  echo "######### Install a Pod network add-on with the following command on the control-plane node ....."
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml;
  # kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
}

echo "######### Start Docker install ....."
install_docker;

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

echo "######### Perform Kubeadm pre-install steps ....."
pre_install_kuberadm;

echo "######### Make an entry in source list ....."
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
  deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "######### Install Kubeadm install ....."
install_kuberadm;

echo "Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"" >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# echo "######### Start Kubeadm install ....."
# start_kubeadmin_master

# echo "######### Confirm that pods are working ....."
# kubectl get pods --all-namespaces;
