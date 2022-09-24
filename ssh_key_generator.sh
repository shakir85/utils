#!/bin/bash

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
