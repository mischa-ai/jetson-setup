#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

add-apt-repository -y ppa:git-core/ppa

apt update
apt upgrade -y

apt install -y \
    htop \
    locate \
    ca-certificates \
    curl \
    gnupg \
    python3-pip \
    lsb-release

# update system database for locate
updatedb
