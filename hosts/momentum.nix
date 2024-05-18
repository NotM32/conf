{
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "momentum";

  imports = [
    ../modules/hardware/t430.nix
    ../modules/boot/legacyboot.nix

    ../modules/desktop/hyprland.nix
  ];

  system.stateVersion = "22.11";
}
