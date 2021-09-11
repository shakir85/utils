#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "You need to run as root ... exiting."
  exit
fi


echo "Available Docker packages:"

PKGS=$(dpkg -l | awk '{ print $2 }' |  grep ^docker)

echo $PKGS

IFS=' ' read -r -a pkgs_array <<< "$PKGS"

echo "Delete Docker packages..."
for pkg in "${pkgs_array[@]}"
do
    sudo apt purge -y "$pkg"
done

echo "Delete Docker directories"
rm -rf /var/lib/docker 
rm -rf /etc/docker
rm -rf /etc/apparmor.d/docker

echo "Delete Docker socket..."
sudo rm -rf /var/run/docker.sock

echo "Delete Docker group..."
groupdel docker

echo "Check if compose binay available"
COMPOSE_BIN=/usr/local/bin/docker-compose
if [[ -f "$COMPOSE_BIN" ]]; then
    echo "$COMPOSE_BIN exists..."
    echo "Delete Docker compose..."
    /usr/local/bin/docker-compose
fi

echo "Done."

