{ lib, ... }: {
  imports = [ ./zerotier.nix ];
  networking.domain = lib.mkDefault "m32.me";
}
