# k8s-kubectl.sh
# handy script to install k8s kubectl on ubuntu 
# run on ubuntu workstation
# By Robert Wang @github.com/robertluwang
# Oct 30, 2021

echo === $(date) Provisioning - k8s-kubectl.sh by $(whoami) start

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl
sudo apt-mark hold kubectl

# cli completion
sudo apt-get install bash-completion -y
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
echo "export do='--dry-run=client -o yaml'" >>~/.bashrc

echo === $(date) Provisioning - k8s-kubectl.sh by $(whoami) end