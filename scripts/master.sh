#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail


if [ -z "$1" ]; then
    echo "Error: The master IP address must be passed as the first argument."
    exit 1
fi

MASTER_IP_ADDRESS="$1"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

# Pull required images

sudo kubeadm config images pull

sudo kubeadm init --apiserver-advertise-address="$MASTER_IP_ADDRESS" --apiserver-cert-extra-sans="$MASTER_IP_ADDRESS" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap



# Configure kubeconfig

mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Install Claico Network Plugin Network 

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
