#!/bin/bash

# barebone centos proxmox-lxc 
# ssh setup for local network only.

dnf upgrade -y
dnf install -y epel-release
dnf install -y net-tools iptables htop vim

systemctl enable sshd
sleep 5
systemctl start sshd
sleep 5

iptables -I INPUT -p tcp --dport 22 -s 192.168.0.0/16 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j REJECT

echo "Done."
