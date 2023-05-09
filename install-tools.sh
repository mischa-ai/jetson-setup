#!/bin/bash

# install jtop
sudo pip3 install -U jetson-stats

# install the wifi power manager disable service
sudo cp disable-wifi-power-management.service /etc/systemd/system/
sudo chmod 664 /etc/systemd/system/disable-wifi-power-management.service
sudo chown root:root /etc/systemd/system/disable-wifi-power-management.service
sudo systemctl enable disable-wifi-power-management.service
sudo systemctl start disable-wifi-power-management.service
# systemctl status disable-wifi-power-management

# install jetson fan control
cd ~
git clone https://github.com/Pyrestone/jetson-fan-ctl.git
cd jetson-fan-ctl/
sudo ./install.sh
# systemctl status automagic-fan
