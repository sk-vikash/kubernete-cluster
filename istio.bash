#! /bin/bash

echo "######### Download the release ....."
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.4.5
export PATH=$PWD/bin:$PATH

echo "######### Install Istio ....."
istioctl manifest apply --set profile=demo
