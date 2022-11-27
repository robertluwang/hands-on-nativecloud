# docker-server.sh
# handy script to install docker on ubuntu 
# run on k8s cluster node (master/worker)
# By Robert Wang @github.com/robertluwang
# Nov 21, 2022

echo === $(date) Provisioning - docker-server.sh by $(whoami) start

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io 

sudo groupadd docker
sudo usermod -aG docker $USER

# turn off swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
sleep 30 
sudo systemctl restart docker

echo === $(date) Provisioning - docker-server.sh by $(whoami) end
