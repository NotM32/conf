{
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [ ../modules/hardware/ovh-vps.nix ];

  system.stateVersion = "22.11";
}
