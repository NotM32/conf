{ specialArgs, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "maple";

  imports = [
    specialArgs.self.nixosModules.server

    ../modules/hardware/ovh-vps.nix
  ];

  system.stateVersion = "22.11";
}
