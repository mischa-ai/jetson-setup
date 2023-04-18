#!/bin/bash

set -e
set -x

if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root"
  exit
fi

mv /var/lib/dpkg/info/ /var/lib/dpkg/backup/
mkdir /var/lib/dpkg/info/
apt-get update
apt-get -f install
mv /var/lib/dpkg/info/* /var/lib/dpkg/backup/
rm -rf /var/lib/dpkg/info
mv /var/lib/dpkg/backup/ /var/lib/dpkg/info/

set +x
