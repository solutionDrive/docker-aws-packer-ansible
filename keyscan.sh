#!/bin/bash

set -e

HOSTNAME_TO_CHECK=$1
HOSTNAME_FINGERPRINT=$2

# inspired by https://github.com/wercker/step-add-to-known_hosts

# make sure $HOME/.ssh exists
if [ ! -d "$HOME/.ssh" ]; then
  echo "$HOME/.ssh does not exists, creating it"
  mkdir -p "$HOME/.ssh"
fi

known_hosts_path="$HOME/.ssh/known_hosts"

if [ ! -f "$known_hosts_path" ]; then
  echo "$known_hosts_path does not exists, touching it and chmod it to 644"
  touch "$known_hosts_path"
  chmod 644 "$known_hosts_path"
fi

# validate <hostname> exists
if [ ! -n "$HOSTNAME_TO_CHECK" ]
then
  echo "missing or empty hostname, usage keyscan.sh <hostname> <fingerprint>"
  exit 1
fi

# validate <fingerprint> exists
if [ ! -n "$HOSTNAME_FINGERPRINT" ]
then
  echo "missing or empty fingerprint, usage keyscan.sh <hostname> <fingerprint>"
  exit 1
fi

types="rsa,dsa,ecdsa"

# Check if ssh-keyscan command exists
set +e
hash ssh-keyscan 2>/dev/null
result=$?
set -e

if [ $result -ne 0 ] ; then
  echo "ssh-keyscan command not found. Cause: ssh-client software probably not installed."
  exit 1
fi

ssh_keyscan_command="ssh-keyscan -t $types"
ssh_keyscan_command="$ssh_keyscan_command $HOSTNAME_TO_CHECK"

ssh_keyscan_result=$(mktemp)

$ssh_keyscan_command > "$ssh_keyscan_result"

echo "Searching for keys that match fingerprint $HOSTNAME_FINGERPRINT"
# shellcheck disable=SC2162,SC2002
cat "$ssh_keyscan_result" | sed "/^ *#/d;s/#.*//" | while read ssh_key; do
ssh_key_path=$(mktemp)
echo "$ssh_key" > "$ssh_key_path"
ssh_key_fingerprint=$(ssh-keygen -l -f "$ssh_key_path" | awk '{print $2}')
if echo "$ssh_key_fingerprint" | grep -q "$HOSTNAME_FINGERPRINT" ; then
  echo "Added a key to $known_hosts_path"
  echo "$ssh_key" | tee -a "$known_hosts_path"
else
  echo "Skipped adding a key to known_hosts, it did not match the fingerprint ($ssh_key_fingerprint)"
fi
rm -f "$ssh_key_path"
done
