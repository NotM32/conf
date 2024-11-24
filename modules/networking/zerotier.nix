{ lib, ... }: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "35c192ce9b255366"
      "233ccaac27077fe3"
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "zerotierone" ];
}
