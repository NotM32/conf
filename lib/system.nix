/* Functions to streamline creating system compositions in the `nixosConfigurations`
   output of a flake
*/
inputs@{ self, nixpkgs, home-manager, sops-nix, ... }: {
  /* Generate a system configuration enforcing the layer/role system */
  makeConfiguration =
    { hardware ? "base",    # Will be selected form self.conf
      system ? "base",      # Will be selected form self.conf
      extraConfig ? [],     # A list of extra modules
      users ? { },
      hostName ? "nixos",
      ...
    }:
    let
      # Open the profile/roles/layers whatever out of the outputs
      hwMods = [ self.conf.hardware.profiles."${hardware}" ];
      sysMods = "${self.conf.system.rolesPath}/${system}.nix";

      # external add-on modules from flake inputs
      libMods = [
        # Home Manager --
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users = users;
        }
        # Secrets --
        sops-nix.nixosModules.sops
      ];

      modules = sysMods ++
                libMods ++
                hwMods ++
                [{ networking.hostName = hostName; }] ++
                extraConfig;

    in nixpkgs.lib.nixosSystem {
      inherit modules;

      specialArgs = {
        inherit inputs; # Share access to the flake inputs in the configuration.
        libm32 = self.lib; # Make this library available in the configuration.
      };
    };

  /* Helper to perform makeSystemConfiguration on an attrset of multiple hosts */
  makeSystemConfigurations = hosts:
    builtins.mapAttrs (hostName: hostConfig:
      self.lib.system.makeSystemConfiguration
      (hostConfig // { inherit hostName; })) hosts;
}
