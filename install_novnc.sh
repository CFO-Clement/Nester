#!/bin/bash

# Installer Ansible s'il n'est pas déjà installé
if ! command -v ansible &> /dev/null
then
    echo "Ansible n'est pas installé. Installation en cours..."
    sudo apt update
    sudo apt install -y ansible
fi

ansible-playbook -i localhost, -c local  novnc_ansible/playbook.yml --ask-become-pass
