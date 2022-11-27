# k8s-reset.sh
# handy script to reset k8s cluster on ubuntu 
# run on k8s cluster node (master/worker)
# By Robert Wang @github.com/robertluwang
# Nov 21, 2022

echo === $(date) Provisioning - k8s-reset.sh by $(whoami) start

sudo kubeadm reset -f --cri-socket unix:///var/run/cri-dockerd.sock 

echo === $(date) Provisioning - k8s-reset.sh by $(whoami) end
