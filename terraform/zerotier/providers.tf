terraform {
  required_providers {
    zerotier = {
      source  = "zerotier/zerotier"
      version = "1.6.0"
    }

    sops = {
      source = "carlpett/sops"
    }
  }
}

provider "sops" {}

provider "zerotier" {
  zerotier_central_token = data.sops_file.zerotier.data["zerotier_central_token"]
}

