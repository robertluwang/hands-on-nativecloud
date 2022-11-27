# k8s-rejoin.sh
# handy script to rejoin k8s cluster on ubuntu 
# run as sudo user on worker node
# By Robert Wang @github.com/robertluwang
# Oct 30, 2021

echo === $(date) Provisioning - k8s-rejoin.sh $1 by $(whoami) start

sudo sed -i '/master/d' /etc/hosts
sudo sed -i '1i$1 master' /etc/hosts

sudo kubeadm reset -f

# join cluster
scp -q -o "StrictHostKeyChecking no" -i $HOME/.ssh/vagrant master:/tmp/kubeadm.log  /var/tmp/kubeadm.log
token=$(cat /var/tmp/kubeadm.log |grep "kubeadm join"|head -1 |awk -Ftoken '{print $2}'|awk '{print $1}')
certhash=$(cat /var/tmp/kubeadm.log |grep discovery-token-ca-cert-hash|tail -1|awk '{print $2}')

sudo kubeadm join master:6443 --token $token \
  --discovery-token-ca-cert-hash $certhash

# allow normal user to run kubectl
if [ -d $HOME/.kube ]; then
  rm -r $HOME/.kube
fi
mkdir -p $HOME/.kube
scp -q -o "StrictHostKeyChecking no" -i $HOME/.ssh/vagrant master:$HOME/.kube/config $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo === $(date) Provisioning - k8s-rejoin.sh $1 by $(whoami) end
