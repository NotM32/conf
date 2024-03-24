/* Functions to streamline creating system compositions in the `nixosConfigurations`
   output of a flake
*/
inputs@{ self, nixpkgs, home-manager, sops-nix, ... }: {
  /* Generate a system configuration supporting all the bits. */
  makeSystemConfiguration = { hardwareProfile, systemConfig, hmConfig ? { }
    , users ? { }, hostName ? "nixos", ... }:
    let
      # Extra module arguments need to be sent to home-manager and nixos separetely.
      extraModuleArgs = {
        libm32 = self.lib;
      } // inputs; # Pass the flake inputs to the module call arguments

    in nixpkgs.lib.nixosSystem {
      modules = systemConfig ++ [
        { _module.args = extraModuleArgs; }

        { networking.hostName = hostName; }
        hardwareProfile

        # Home Manager --
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = extraModuleArgs;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users = users;
        }
        hmConfig

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
