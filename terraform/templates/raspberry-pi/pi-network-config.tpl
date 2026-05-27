network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - ${addresses_ip}
      routes:
        - to: default
          via: ${gateway}
      nameservers:
        addresses: ${dns_servers}