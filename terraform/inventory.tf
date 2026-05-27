# Generate script to download os and write it to raspberry pi sd card
# with proper cloud-init config
resource "local_file" "pi_prepare_os" {
  for_each = local.pi_nodes
  filename = "${abspath("${path.module}/../raspberry-pi/${each.value.hostname}/${each.value.hostname}-prepare-os.sh")}"

  content = templatefile("${path.module}/templates/raspberry-pi/pi-prepare-os.tpl", {
    os_version = each.value.os_version
    os_name    = each.value.os_name
    hostname   = each.value.hostname
    role       = each.value.role
  })

  file_permission = "0700"
}

# Generate cloud-init meta-data config file
resource "local_file" "pi_meta_data" {
  for_each = local.pi_nodes
  filename = "${abspath("${path.module}/../raspberry-pi/${each.value.hostname}/${each.value.hostname}-meta-data")}"

  content = templatefile("${path.module}/templates/raspberry-pi/pi-meta-data.tpl", {
    hostname = each.value.hostname
  })

  file_permission = "0600"
}

# Generate cloud-init network-config file
resource "local_file" "pi_network_config" {
  for_each = local.pi_nodes
  filename = "${abspath("${path.module}/../raspberry-pi/${each.value.hostname}/${each.value.hostname}-network-config")}"

  content = templatefile("${path.module}/templates/raspberry-pi/pi-network-config.tpl", {
    addresses_ip = each.value.static_ip
    gateway      = var.cluster_config.gateway
    dns_servers  = jsonencode(var.cluster_config.dns_servers)
  })

  file_permission = "0600"
}

# Generate cloud-init user-data config file
resource "local_file" "pi_user_data" {
  for_each = local.pi_nodes
  filename = "${abspath("${path.module}/../raspberry-pi/${each.value.hostname}/${each.value.hostname}-user-data")}"

  content = templatefile("${path.module}/templates/raspberry-pi/pi-user-data.tpl", {
    hostname        = each.value.hostname
    ssh_public_keys = var.cluster_config.ssh_public_keys
  })

  file_permission = "0600"
}

resource "local_file" "ansible_inventory" {
  filename = "${abspath("${path.module}/../ansible/inventory.ini")}"

  content = templatefile("${path.module}/templates/ansible/inventory.tftpl", {
    pi_nodes = local.pi_nodes
  })
}

resource "local_file" "role_pi5_raid_nfs" {
  filename = "${abspath("${path.module}/../ansible/roles/pi5-raid-nfs/defaults/main.yml")}"

  content = templatefile("${path.module}/templates/ansible/roles/pi5-raid-nfs/defaults/main.tftpl", {
    node = var.cluster_nodes["pi5"]
  })
}
