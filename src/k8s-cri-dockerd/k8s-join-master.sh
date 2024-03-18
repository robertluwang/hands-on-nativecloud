# k8s-join-master.sh
# handy script to join k8s cluster on ubuntu
# run on k8s master node
# By Robert Wang @github.com/robertluwang
# Nov 21, 2022
# $1 - master/api server ip

echo === $(date) Provisioning - k8s-join-master.sh $1 by $(whoami) start

sudo sed -i '/master/d' /etc/hosts
sudo sed -i "1i$1 master" /etc/hosts

# join cluster
JOINTOKEN=$(kubeadm token create --print-join-command)

sudo $JOINTOKEN --cri-socket unix:///var/run/cri-dockerd.sock

echo === $(date) Provisioning - k8s-join-master.sh $1 by $(whoami) end
