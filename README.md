# Kubernetes cluster on the AWS

Repo contains script to create kubernetes cluster in AWS.

## Disclaimer

Works only on Ubuntu machine.

## Technologies Used

  * AWS
  * Terraform
  * Bash
  * VSCode
  
## Prerequite

Create private and public key required in the script by executing the below command.

`ssh-keygen -f test-kube -P ""`

## Installation/Usages


Run below command to provision the infrastructure.

`terraform apply --auto-approve to run the terraform`

Once infrastructure is created following will be output, assume `a1.b1.c1.d1` is public ip of master node & `a2.b2.c2.d2` is public ip of worker node

```
instance_kube_admin_public_ip = a1.b1.c1.d1
instance_kube_node_1_public_ip = a2.b2.c2.d2
```

The AWS instance can be accessed by running below command from terminal/command prompt/putty.

```
ssh -i test-kube ubuntu@a1.b1.c1.d1
ssh -i test-kube ubuntu@a2.b2.c2.d2
```

## Master & worker node

Follow below steps to create master and wroker node.

```
step a) Run `master_node.bash` on instance with ip a1.b1.c1.d1 
step b) Allow other node with ip a2.b2.c2.d2 to join the mster node by follow the instruction from step (a)
```

## Test

Run following command to ensure the kubernetes cluster is provisioned correctly.

```
kubectl get nodes
kubectl get pods --all-namespace
```