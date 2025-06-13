#!/bin/bash
# This script generates SSH keys for Ansible provisioning

# Create ssh directory only if it doesn't exist
mkdir -p ./ssh
chmod 700 ./ssh

KEY_PATH=./ssh/ansible-provision-key

# Generate keys only if they don't exist
if [ ! -f "$KEY_PATH" ]; then
  ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -C "remla25-18" -N ""
  chmod 600 "$KEY_PATH"
fi

# Ensure correct permissions even if keys are already there
chmod 600 "$KEY_PATH"