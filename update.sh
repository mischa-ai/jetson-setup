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

# install jetson fan controll
git clone https://github.com/Pyrestone/jetson-fan-ctl.git
cd jetson-fan-ctl/
./install.sh
service automagic-fan status

# install jtop
pip3 install -U jetson-stats

# install the wifi power manager disable service
cp disable-wifi-power-management.service /etc/systemd/system/
chmod 664 /etc/systemd/system/disable-wifi-power-management.service
chown root:root /etc/systemd/system/disable-wifi-power-management.service
systemctl enable disable-wifi-power-management.service
systemctl start disable-wifi-power-management.service
service disable-wifi-power-management status
