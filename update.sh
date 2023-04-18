#!/bin/bash

set -e
set -x

if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

apt autoremove -y libreoffice*

add-apt-repository -y ppa:git-core/ppa

apt clean
apt update
apt upgrade -y

apt install -y \
    htop \
    locate \
    ca-certificates \
    curl \
    gnupg \
    lsb-release


# Check if Docker is up-to-date
installed_version=$(docker version --format '{{.Server.Version}}')
architecture=$(dpkg --print-architecture)
repo_url="https://download.docker.com/linux/ubuntu/dists/$(lsb_release -cs)/pool/stable/${architecture}/"
latest_version=$(curl -s "${repo_url}" | grep -oP "docker-ce_\K.*(?=${architecture}.deb)" | sed 's/-.*//g' | sort -V | tail -n1)
if [[ "${installed_version}" != "${latest_version}" ]]; then
    echo "Docker is outdated (installed version: ${installed_version}, latest version: ${latest_version})"
    apt-get purge docker docker-engine docker.io containerd runc
    rm -rf /var/lib/docker/

    mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo "Docker is up to date (version: ${installed_version})"
fi

if grep -q docker /etc/group; then
    echo "docker group already exists"
else
    groupadd docker
fi

usermod -aG docker $USER

# install jtop
pip3 install -U jetson-stats

# install the wifi power manager disable service
cp disable-wifi-power-management.service /etc/systemd/system/
chmod 664 /etc/systemd/system/disable-wifi-power-management.service
chown root:root /etc/systemd/system/disable-wifi-power-management.service
systemctl enable disable-wifi-power-management.service
systemctl start disable-wifi-power-management.service
# systemctl status disable-wifi-power-management

# install jetson fan control
cd ~
git clone https://github.com/Pyrestone/jetson-fan-ctl.git
cd jetson-fan-ctl/
./install.sh
# systemctl status automagic-fan

# update system database for locate
updatedb

set +x
