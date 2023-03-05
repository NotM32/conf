{ lib, pkgs, config, ... }:
{
  nginx = {
    enable = true;
    clientMaxBodySize = "10G";
  };
}
