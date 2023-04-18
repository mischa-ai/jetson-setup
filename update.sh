apt autoremove libreoffice*

apt remove docker docker-engine docker.io containerd runc
rm -rf /var/lib/docker/

add-apt-repository ppa:git-core/ppa

apt clean
apt update
apt upgrade

apt install \
    htop \
    locate\
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

groupadd docker
usermod -aG docker $USER
newgrp docker
updatedb

pip3 install -U jetson-stats

# install the wifi power manager disable service
systemctl enable disable-wifi-power-management.service
systemctl start disable-wifi-power-management.service
