#cloud-config
hostname: ${hostname}
manage_etc_hosts: true

# GLOBAL SSH CONFIGURATION
# This sets "PasswordAuthentication no" in /etc/ssh/sshd_config
# Users can only login via SSH keys.
ssh_pwauth: false

users:
  - name: ansible
    gecos: Ansible automation only user
    groups: [sudo, adm]
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell: /bin/bash

    ssh_authorized_keys:
  %{ for key in ssh_public_keys ~}
    - ${key}
  %{ endfor ~}

