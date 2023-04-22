{ lib, pkgs, config, ... }:
{
  imports =
    [ ./server/ssh.nix
      ./server/letsencrypt.nix
      ./server/gitea.nix
      ./server/backups.nix
      ./server/nginx.nix
      ./network/zerotier.nix
    ];
}
