/* Functions to streamline creating system compositions in the `nixosConfigurations`
   output of a flake
*/
inputs@{ self, nixpkgs, home-manager, sops-nix, ... }: {
  /* Generate a system configuration supporting all the bits. */
  makeSystemConfiguration = { hardwareProfile, systemConfig, hmConfig ? { }
    , users ? { }, hostName ? "nixos", ... }:
    let
      # Home Mananger --
      hmModules = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users = users;
      } // hmConfig;

      # Set a default hostname --
      hostnameConfig = { networking.hostName = hostName; };

    in nixpkgs.lib.nixosSystem {
      modules = systemConfig ++ [
        { _module.args = inputs; } # Pass the flake inputs to the module call arguments
        { _module.args.libm32 = self.lib; } # Pass the flake inputs to the module call arguments
        hardwareProfile
        hostnameConfig
        # Home Manager --
        home-manager.nixosModules.home-manager
        hmModules
        # Secrets --
        sops-nix.nixosModules.sops
      ];
    };

  /* Helper to perform makeSystemConfiguration on an attrset of multiple hosts */
  makeSystemConfigurations = hosts:
    builtins.mapAttrs (hostName: hostConfig:
      self.lib.system.makeSystemConfiguration
      (hostConfig // { inherit hostName; })) hosts;
}
