{ lib, ... }:
{
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      # M32 Srv Interlink
      "233ccaac27077fe3"
      # Churchill Interlink
      "35c192ce9b255366"
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "zerotierone"
  ];
}
