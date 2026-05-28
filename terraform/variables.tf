variable "cluster_nodes" {
  description = "Home Lab cluster nodes configuration"
  type = map(object({
    mac_address = string
    static_ip   = string
    hostname    = string
    role        = string
    os_version  = string
    os_name     = string
    tags        = list(string)
  }))
  default = {
    "pi5" = {
      mac_address = "2c:cf:67:f0:5e:8e"
      static_ip   = "192.168.88.5/24"
      hostname    = "pi5"
      role        = ""
      os_version  = "24.04.4"
      os_name     = "ubuntu-24.04.4-preinstalled-server-arm64+raspi"
      tags        = ["pi", "pi5"]
    },
    "pi3" = {
      mac_address = "b8:27:eb:ef:91:bc"
      static_ip   = "192.168.88.3/24"
      hostname    = "pi3"
      role        = ""
      os_version  = "24.04.4"
      os_name     = "ubuntu-24.04.4-preinstalled-server-arm64+raspi"
      tags        = ["pi", "pi3"]
    },
  }
}

variable "cluster_config" {
  description = "Global cluster configuration"
  type = object({
    domain          = string
    gateway         = string
    dns_servers     = list(string)
    timezone        = string
    ssh_public_keys = list(string)
  })
  default = {
    domain      = "homelab.local"
    gateway     = "192.168.88.1"
    dns_servers = ["192.168.88.1"]
    timezone    = "UTC"
    ssh_public_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEk2NJ84oCGIpKIJ9zz+8lid8vFg/qHW3UvJeDe+eLHE ansible home lab eurocom",
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDaf2argvNXeYViOuQJZCpllMWKFEOW8GzEtjgOx08p bigbox ansible homelab",
    ]
  }
}
