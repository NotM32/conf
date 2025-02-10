#!/bin/sh
export TF_VAR_host_netconfigurations=$(nix eval --json  .#nixosConfigurations --apply "builtins.mapAttrs (name: value: value.config.conf.network.zerotier.networks)")
tofu plan -out plan
tofu apply plan
