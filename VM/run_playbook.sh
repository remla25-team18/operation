#!/bin/bash

echo "Choose a playbook to run:"
echo "1) Cluster Configuration"
echo "2) Finalization"
echo "3) Istio Installation"
read -p "Enter choice [1-3] (leave empty for full provisioning): " choice

case $choice in
  1)
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/cluster.yml
    ;;
  2)
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/finalization.yml
    ;;
  3)
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/istio.yml
    ;;
  "")
    echo "Running full provisioning: Finalization → Istio → Cluster..."
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/finalization.yml
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/istio.yml
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/cluster.yml
    ;;
  *)
    echo "Invalid choice."
    ;;
esac
