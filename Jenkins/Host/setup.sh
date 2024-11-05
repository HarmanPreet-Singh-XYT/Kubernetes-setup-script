#Get latest scripts
git clone https://github.com/scriptcamp/kubernetes-jenkins

#create namespace
kubectl create namespace devops-tools

#Apply serviceAccount.yaml
kubectl apply -f ./kubernetes-jenkins/serviceAccount.yaml

#Apply Volume
kubectl create -f ./kubernetes-jenkins/volume.yaml

#Apply deployment 
kubectl apply -f ./kubernetes-jenkins/deployment.yaml

#Apply service
kubectl apply -f ./kubernetes-jenkins/service.yaml

echo "visit http://<node-ip>:32000 for dashboard, any node ip will work. Service is at Port 32000. Get password with this - kubectl exec -it <full pod name of jenkins> cat /var/jenkins_home/secrets/initialAdminPassword -n devops-tools"