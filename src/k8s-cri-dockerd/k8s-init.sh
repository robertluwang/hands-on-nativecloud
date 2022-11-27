# k8s-init.sh
# handy script to init k8s cluster on ubuntu 
# run on k8s master node only
# By Robert Wang @github.com/robertluwang
# Nov 21, 2022
# $1 - master/api server ip

echo === $(date) Provisioning - k8s-init.sh $1 by $(whoami) start

if [ -z "$1" ];then
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem --cri-socket unix:///var/run/cri-dockerd.sock | tee /var/tmp/kubeadm.log
else
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=$1 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem --cri-socket unix:///var/run/cri-dockerd.sock | tee /var/tmp/kubeadm.log
fi

# allow normal user to run kubectl
if [ -d $HOME/.kube ]; then
  rm -r $HOME/.kube
fi
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install calico network addon
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/custom-resources.yaml

# allow run on master
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

echo === $(date) Provisioning - k8s-init.sh $1 by $(whoami) end
