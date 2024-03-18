# cri-dockerd.sh
# handy script to install cri-dockerd on ubuntu 
# run on k8s cluster node (master/worker)
# By Robert Wang @github.com/robertluwang
# Nov 26, 2022

echo === $(date) Provisioning - cri-dockerd by $(whoami) start

# cri-dockerd 
VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz
tar xvf cri-dockerd-${VER}.amd64.tgz
sudo mv cri-dockerd/cri-dockerd /usr/local/bin/
sudo chmod +x /usr/local/bin/cri-dockerd

wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket

sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/cri-docker.*
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sleep 30
sudo systemctl restart cri-docker.service

echo === $(date) Provisioning - cri-dockerd by $(whoami) end
