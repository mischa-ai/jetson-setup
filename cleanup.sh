#!/bin/bash

sudo apt autoremove -y libreoffice* thunderbird chromium-browser aisleriot gnome-mahjongg gnome-mines gnome-sudoku
sudo apt purge docker docker-engine docker.io containerd runc
sudo rm -rf /var/lib/docker/

sudo apt clean
sudo apt update
