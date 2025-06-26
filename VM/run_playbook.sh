#!/bin/bash

echo "Choose a playbook to run:"
echo "[Press enter] Full provisioning"
echo "1) Cluster Configuration"
echo "2) Finalization"
echo "3) Istio Installation"
read -p "Press enter or choose [1-3] (any other character to abort): " choice

case $choice in
  "")
    echo "Running full provisioning: Finalization → Istio"
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/finalization.yml
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/istio.yml
    ;;
  1)
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/cluster.yml
    ;;
  2)
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/finalization.yml
    ;;
  3)
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/istio.yml
    ;;
  *)
    echo "Invalid choice."
    ;;
esac
