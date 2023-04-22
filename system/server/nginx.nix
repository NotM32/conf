{ lib, pkgs, config, ... }:
{
  services.nginx = {
    enable = true;
    clientMaxBodySize = "10G";
  };
}
