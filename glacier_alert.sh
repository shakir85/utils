#!/bin/ash

# Grep last backup time and email it
body=$(cat /usr/syno/etc/packages/GlacierBackup/synoglacierbkp.conf | grep -e "\[" -e last_bkp_time -e last_bkp_status)
headers="From: Synology <$1>"

/usr/bin/php -r "mail('$1', 'Glacier backup status', '$body', '$headers');";
