{ lib, pkgs, config, ... }:
{
  services.nginx = {
    enable = true;
    clientMaxBodySize = "10G";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
