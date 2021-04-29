variable "hcloud_token" {
  type = string
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "TNH-Test"
  public_key = file("~/.ssh/id_ed25519.pub")
}

module "tnh-k3s" {
  # source = "git@github.com:NerdyHamster/hetzner-k3s.git"
  source       = "../../hetzner-k3s"
  hcloud_token = var.hcloud_token
  ssh_keys     = [hcloud_ssh_key.default.id]
  worker_groups = {
    "cx21" = 2
    "cx31" = 4
  }
}

output "workers_ipv4" {
  depends_on = [module.tnh-k3s]
  value      = module.tnh-k3s.workers_ipv4
}
