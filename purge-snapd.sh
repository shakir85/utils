#!/bin/bash

echo "######################################"
echo "## I don't like Canonical's garbage! #"
echo "######################################"

# Stop snap deamon
systemctl stop snapd

# snapd package removal
apt-mark hold snapd
apt autoremove --purge -y snapd gnome-software-plugin-snap

# Remove dirctories
rm -rf /var/cache/snapd/
rm -fr ~/snap
rm -rf /snap
rm -rf /var/snap
rm -rf /var/lib/snapd

# Reload
systemctl daemon-reload

echo "Done."

# Enjoy lean and clean Ubuntu.