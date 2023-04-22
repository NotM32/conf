{ lib, pkgs, config, ... }:
{
  imports =
    [ ./server/ssh
      ./server/letsencrypt
      ./server/gitea
      ./server/backups
      ./server/nginx
      ./system/network/zerotier
    ];
}
