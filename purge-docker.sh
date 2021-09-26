#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "You need to run as root... exiting."
  exit
fi

echo "Check Docker service in systemd..."

CHECK_SYSD=$(systemctl list-units | grep docker)
if [[ ! -z $CHECK_SYSD ]] ; then
  systemctl stop docker.service
else
  echo "Docker service seems to be inactice..."
fi

echo "Looking for available Docker packages... "

PKGS=$(dpkg -l | awk '{ print $2 }' |  grep ^docker)

echo $PKGS

IFS=' ' read -r -a pkgs_array <<< "$PKGS"

echo "Delete Docker packages..."
for pkg in "${pkgs_array[@]}"
do
    apt purge -y "$pkg"
done

rm -rf /var/lib/docker 
rm -rf /etc/docker
rm -rf /etc/apparmor.d/docker
echo "Docker directories deleted."

sudo rm -rf /var/run/docker.sock
echo "Docker socket deleted."

groupdel docker
echo "Docker group deleted."

echo "Check if compose binary installed..."
COMPOSE_BIN=/usr/local/bin/docker-compose
if [[ -f "$COMPOSE_BIN" ]]; then
    echo "$COMPOSE_BIN exists..."
<<<<<<< HEAD
    /usr/local/bin/docker-compose
    echo "Docker compose delete."
    else
    echo "No docker compose installed."
=======
    echo "Delete Docker compose..."
    rm -rf /usr/local/bin/docker-compose
>>>>>>> 6b59ffc7e58b2f87d77fdc4196404d42c1c76f46
fi

echo "Done."

