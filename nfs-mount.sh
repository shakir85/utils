#!/bin/bash

# Mount NFS folder to fstadb

read -r "Enter NAS IP address..." IP
read -r "Enter NAS mounting point's absolute path..." NAS_Vol
read -r "Enter local mounting point absolute path..." Local_Vol


if ! grep -q "$Local_Vol" /etc/fstab ; 
    then
        echo "# Custom NAS Volume" >> /etc/fstab
        #  $NASiP:/volume1/nfs-data /mnt/nfs-data nfs nouser,rsize=8192,wsize=8192,atime,auto,rw,dev,exec,suid 0 0
        echo "$IP:$NAS_Vol $Local_Vol nfs nouser,rsize=8192,wsize=8192,atime,auto,rw,dev,exec,suid 0 0" >> /etc/fstab
        mount -a
    else
        echo "This volume is already mounted in fstab. Aborting."
        echo " $Local_Vol "
fi
