#!/bin/bash

### --------------------------------------------------------------
### Fix Ubuntu arm64 when struggles to get an IPv4 + other things
### --------------------------------------------------------------
##
## Set ipv4, default gw, and dns (install ifconfig via net-tools)
##
# set ipv4
ifconfig eth0 192.168.1.119 netmask 255.255.255.0 up

# set dns server to pihole
# or use `resolvectl` instead (recommended)
echo "nameserver 192.168.1.xx" > /etc/resolv.conf

# set default gateway
route add default gw 192.168.1.1

# test
ping -c5 google.com

## Take down an interface
# ip addr show
# ip link set eth0 up
# ip link set eth0 down
## Show current routing or edit /etc/netplan/*.yaml & run `netplan apply`
# ip route show
