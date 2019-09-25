#!/bin/bash

set -o pipefail

if [ -n "${PLUGIN_SSH_KEY}" ]; then
    echo "Adding SSH Key..."
    mkdir -p ~/.ssh/
    echo -e "$PLUGIN_SSH_KEY" > ~/.ssh/id_rsa
    chmod 0600 ~/.ssh/id_rsa
fi
