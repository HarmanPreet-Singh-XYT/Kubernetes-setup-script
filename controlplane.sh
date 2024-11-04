#!/bin/bash

# Update package list and install dependencies
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release gpg

# Disable swap permanently
sudo swapoff -a
sudo sed -i '/swap/s/^/#/' /etc/fstab

# Confirm swap is off
if free | awk '/^Swap:/ {exit !$2}'; then
  echo "Swap is still on. Please check /etc/fstab manually for active swap entries."
else
  echo "Swap is successfully disabled and will remain disabled after reboot."
fi

# Install containerd
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# Install Runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.10/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc

# Add Kubernetes apt repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package list and install kubeadm, kubelet, kubectl
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Load necessary modules for kubelet
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Apply sysctl params without reboot
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# Enable and start kubelet
sudo systemctl enable --now kubelet
sleep 10

# Initialize Kubernetes with containerd as the runtime
sudo kubeadm init --cri-socket /run/containerd/containerd.sock --pod-network-cidr=10.244.0.0/16

# Set up kubeconfig for the current user (if non-root)
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico network plugin
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml
sed -i 's/192\.168\.0\.0\/16/10.244.0.0\/16/g' custom-resources.yaml
kubectl apply -f custom-resources.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

# Generate join command for worker nodes
JOIN_CMD=$(kubeadm token create --print-join-command)

echo "Kubernetes control plane setup complete."
echo "To add worker nodes, run the following command on each worker node:"
echo $JOIN_CMD
