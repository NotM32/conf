{ lib, ... }: {
  imports = [
    ./firewall.nix
    ./zerotier.nix
  ];

  networking.domain = lib.mkDefault "m32.io";
}
