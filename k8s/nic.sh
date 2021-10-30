# nic.sh
# handy script to setup static nic eth0 on ubuntu 
# By Robert Wang @github.com/robertluwang
# Oct 30, 2021
# $1 - static nic ip on NAT hyper-v switch 

echo === $(date) Provisioning - nic $1 by $(whoami) start  

cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      dhcp6: no
      addresses: [$1/24]
      gateway4: 192.168.120.1
      nameservers:
        addresses: [4.2.2.1, 4.2.2.2, 208.67.220.220]
EOF

cat /etc/netplan/01-netcfg.yaml

sudo netplan apply

echo eth0 setting

ip addr
ip route
ping -c 2 google.ca

echo === $(date) Provisioning - nic $1 by $(whoami) end
