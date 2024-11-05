#!/bin/bash

# Clone the repository
git clone https://github.com/scriptcamp/kubernetes-jenkins

# Prompt user for custom Jenkins image
echo "Do you have a custom Jenkins image? (y/n)"
read -r custom_image_response

# If user has a custom image, ask for its name
if [[ "$custom_image_response" == "y" ]]; then
  echo "Please provide the custom Jenkins image (e.g., 'myrepo/jenkins:latest'):"
  read -r custom_image
fi

# Modify deployment.yaml if a custom image is provided
if [[ -n "$custom_image" ]]; then
  sed -i "s|jenkins/jenkins:lts|$custom_image|g" ./kubernetes-jenkins/deployment.yaml
  echo "Updated deployment.yaml with custom image: $custom_image"
else
  echo "No custom image provided. Using default Jenkins image: jenkins/jenkins:lts"
fi

# Create namespace
kubectl create namespace devops-tools

# Apply serviceAccount.yaml
kubectl apply -f ./kubernetes-jenkins/serviceAccount.yaml

# Apply Volume
kubectl create -f ./kubernetes-jenkins/volume.yaml

# Apply deployment
kubectl apply -f ./kubernetes-jenkins/deployment.yaml

# Apply service
kubectl apply -f ./kubernetes-jenkins/service.yaml
