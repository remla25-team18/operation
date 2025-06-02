#!/bin/bash
# This script generates SSH keys for Ansible provisioning
mkdir ./ssh
ssh-keygen -t rsa -b 4096 -f ./ssh/ansible-provision-key -C "remla25-18" -N ""

chmod 700 ./ssh
chmod 600 ./ssh/ansible-provision-key