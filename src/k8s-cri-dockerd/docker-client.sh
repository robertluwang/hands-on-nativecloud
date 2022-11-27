# docker-client.sh
# handy script to install docker client on ubuntu 
# run on ubuntu workstation
# By Robert Wang @github.com/robertluwang
# Nov 21, 2022

echo === $(date) Provisioning - docker-client.sh by $(whoami) start

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce-cli 

# turn off swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

echo === $(date) Provisioning - docker-client.sh by $(whoami) end
