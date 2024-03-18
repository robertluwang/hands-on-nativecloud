# k8s-join-worker.sh
# handy script to join k8s cluster on ubuntu
# run on k8s worker node
# By Robert Wang @github.com/robertluwang
# Nov 21, 2022
# $1 - master/api server ip

echo === $(date) Provisioning - k8s-join-worker.sh $1 by $(whoami) start

sudo sed -i '/master/d' /etc/hosts
sudo sed -i "1i$1 master" /etc/hosts

# add private key 
curl -Lo $HOME/.ssh/vagrant https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant
chmod 0600 $HOME/.ssh/vagrant

# join cluster
JOINTOKEN=$(ssh -q -o "StrictHostKeyChecking no" -i $HOME/.ssh/vagrant master kubeadm token create --print-join-command)

sudo $JOINTOKEN --cri-socket unix:///var/run/cri-dockerd.sock

# allow normal user to run kubectl
if [ -d $HOME/.kube ]; then
  rm -r $HOME/.kube
fi
mkdir -p $HOME/.kube
scp -q -o "StrictHostKeyChecking no" -i $HOME/.ssh/vagrant master:$HOME/.kube/config $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo === $(date) Provisioning - k8s-join-worker.sh $1 by $(whoami) end
