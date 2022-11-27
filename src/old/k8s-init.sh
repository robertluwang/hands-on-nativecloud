# k8s-init.sh
# handy script to init k8s cluster on ubuntu 
# By Robert Wang @github.com/robertluwang
# Oct 30, 2021
# $1 - master/api server ip

echo === $(date) Provisioning - k8s-init.sh $1 by $(whoami) start

if [ -z "$1" ];then
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem | tee /var/tmp/kubeadm.log
else
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=$1 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem | tee /var/tmp/kubeadm.log
fi

# allow normal user to run kubectl
if [ -d $HOME/.kube ]; then
  rm -r $HOME/.kube
fi
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install calico network addon
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

# allow run on master
kubectl taint nodes --all node-role.kubernetes.io/master-

echo === $(date) Provisioning - k8s-init.sh $1 by $(whoami) end
