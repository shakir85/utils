#!/bin/bash

# Script to generate ssh keys.
# Usage:
#   1. Run this script in the destination server, supply a meaningful hostname and username.
#   2. Copy the generate public key (<foo>.pub) into the server's ~/.ssh/authorized_keys
#   3. Copy the generated private key into your machine (or to 1Password to share it with the team)
#   4. Delete the keys from the server. No need to keep them there.
#   5. Now you can use the generate private key to ssh to the server. Chmod it 400 (or 644) first.


# Set bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'


# Get the full directory path regardless where this script is being called from
# Taken from: https://stackoverflow.com/a/246128
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Avoid overwriting previously created ssh keys
RANDOM_STRING=$(echo $RANDOM | md5sum | head -c 4; echo;)

echo "Enter hostname... [e.g. prod-server]"
read -r hostname
echo "Enter username... [e.g. admin]"
read -r username

ssh-keygen -t rsa -b 2048 -C "$username@$hostname" -q -N "" -f "$SCRIPT_DIR/sshkey-$username@$hostname-$RANDOM_STRING"
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "Error"
else
    echo "Done."
fi
