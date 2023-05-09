#!/bin/bash

sudo python3 -m pip install --upgrade pip

# install jtop
sudo python3 -m pip install -U jetson-stats

# install jetson fan control
cd ~
git clone https://github.com/Pyrestone/jetson-fan-ctl.git
cd jetson-fan-ctl/
sudo ./install.sh
# systemctl status automagic-fan
