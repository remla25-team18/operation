#!/bin/bash

echo "Choose a playbook to run:"
echo "1) Cluster Configuration"
echo "2) Finalization"
echo "3) Istio Installation"
echo "4) Provisioning without Cluster Configuration"
read -p "Enter choice [1-4] (leave empty for full provisioning, any other character to abort): " choice

case $choice in
  "")
    echo "Running full provisioning: Finalization → Istio → Cluster..."
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/finalization.yml
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/istio.yml
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/cluster.yml
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
  4)
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/finalization.yml
    ansible-playbook -u vagrant -i 192.168.56.100, provisioning/ansible/istio.yml
    ;;
  *)
    echo "Invalid choice."
    ;;
esac
