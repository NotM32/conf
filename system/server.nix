{ lib, pkgs, config, ... }:
{
  imports =
    [ ./server/ssh.nix
      ./server/letsencrypt.nix
      ./server/gitea.nix
    ];
}
