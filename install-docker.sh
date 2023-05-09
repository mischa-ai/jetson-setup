#!/bin/bash

# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "Warning: Docker is already installed. Checking for updates."

    # Check if Docker is up-to-date
    installed_version=$(docker version --format '{{.Server.Version}}')
    architecture=$(dpkg --print-architecture)
    repo_url="https://download.docker.com/linux/ubuntu/dists/$(lsb_release -cs)/pool/stable/${architecture}/"
    latest_version=$(curl -s "${repo_url}" | grep -oP "docker-ce_\K.*(?=${architecture}.deb)" | sed 's/-.*//g' | sort -V | tail -n1)
    if [[ "${installed_version}" != "${latest_version}" ]]; then
        echo "Docker is outdated (installed version: ${installed_version}, latest version: ${latest_version})"
        apt update
        apt upgrade -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    else
        echo "Docker is up to date (version: ${installed_version})"
    fi
else
    echo "Docker is not installed. Installing the latest version."

    mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo systemctl enable docker
fi

if grep -q docker /etc/group; then
    echo "docker group already exists"
else
    groupadd docker
fi

usermod -aG docker jetbot
newgrp docker
