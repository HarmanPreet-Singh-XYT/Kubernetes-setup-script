<h1 align="center" id="title">Kubernetes Cluster Setup with Containerd Script</h1>

<p id="description">This repository contains scripts to automate the setup of a Kubernetes control plane and worker nodes on Ubuntu servers. The control plane script installs `containerd` as the container runtime disables swap and initializes the control plane with networking. The worker node script installs `containerd` and prepares each node to join the control plane.</p>

## Prerequisites

- **Ubuntu server** (tested on Ubuntu server 20.04/22.04)
- **Root or sudo privileges** on each server
- **Same network** connectivity between the control plane and worker nodes
  
  
<h2>🧐 Features</h2>

Here're some of the project's best features:

*   Installs \`containerd\` as the container runtime
*   Disables swap permanently for Kubernetes compatibility
*   Installs Kubernetes components (\`kubeadm\` \`kubelet\` \`kubectl\`)
*   Initializes the Kubernetes control plane
*   Applies Calico as the Container Network Interface (CNI)
*   Generates a join command for adding worker nodes to the cluster
*   From Scratch to Intialising Kubeadm

<h2>🛠️ Installation Steps:</h2>
<h3>There are two ways to run script</h3>
<h3>Primary Method</h3>
<p> Run these Scripts</p>
<p>1. for control plane </p>

```
sudo wget -qO- https://raw.githubusercontent.com/HarmanPreet-Singh-XYT/Kubernetes-setup-script/refs/heads/main/Kubernetes/controlplane.sh | bash
```

<p>2. for Worker Node </p>

```
sudo wget -qO- https://github.com/HarmanPreet-Singh-XYT/Kubernetes-setup-script/blob/main/Kubernetes/worker.sh | bash
```

<h3> Other Method </h3>

<p>1. Set Up the Control Plane Node</p>

```
git clone https://github.com/HarmanPreet-Singh-XYT/Kubernetes-setup-script.git
```

<p>2. navigate into directory</p>

```
cd ./Kubernetes-setup-script
```

<p>3. Make the control plane script executable:</p>

```
chmod +x controlplane.sh
```

<p>4. Run the control plane script:</p>

```
sudo ./controlpanel.sh
```

<p>5. Get the Join Command at the end and use in other nodes to connect them with control plane: if you want token again</p>

```
kubeadm token create --print-join-command
```

<p>6. Repeat these steps with worker.sh on worker node that you want to connect</p>

<h2>Troubleshooting:</h2>
<ul>
<li><b>Swap is re-enabled after reboot</b>: Ensure /etc/fstab has all swap entries commented out.</li>
<li><b>Worker nodes cannot connect</b>: Verify that the control plane IP address and join token are correct, and check for any firewall restrictions.</li>
</ul>

<h2>🍰 Contribution Guidelines:</h2>

Raise issue before creating PR; on assignment create PR.

<h2>🛡️ License:</h2>

This project is licensed under the MIT LICENSE

