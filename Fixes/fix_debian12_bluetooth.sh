#!/bin/bash
#
# Due to Debian being a stability-focused distro, the experimental DBus plugin is not enabled by default, 
# which causes issues with Bluetooth connecting through high-fidelity playback.
#

apt-get install pipewire pipewire-audio pipewire-pulse wireplumber libspa-0.2-bluetooth
sed -i "s/#Experimental = false/Experimental = true/" /etc/bluetooth/main.conf
systemctl restart bluetooth
