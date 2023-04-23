{ lib, pkgs, config, ... }:
{
  imports =
    [ ./default.nix
      ./server/ssh.nix
      ./server/letsencrypt.nix
      ./server/gitea.nix
      ./server/backups.nix
      ./server/nginx.nix
      ./network/zerotier.nix
    ];
}
