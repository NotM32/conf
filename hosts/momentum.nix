{
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    ../modules/hardware/t430.nix
    ../modules/boot/legacyboot.nix
  ];

  system.stateVersion = "22.11";
}
