{ lib, ... }: {
  imports = [
    ./firewall.nix
    ./zerotier.nix
  ];

  networking.useDHCP = lib.mkDefault true;

  networking.domain = lib.mkDefault "m32.io";
}
