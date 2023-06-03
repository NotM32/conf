/* Functions to streamline creating system compositions in the `nixosConfigurations`
   output of a flake
*/
inputs@{ self, nixpkgs, home-manager, ... }:
{
  /* Generate a system configuration supporting all the bits. */
  makeSystemConfiguration = { hardwareProfile, systemConfig, hmConfig ? { }, users ? { }, hostName ? "nixos", ... }:
    let
      # Home Mananger --
      hmModules =
        { home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users = users;
        } // hmConfig;

      # Set a default hostname --
      hostnameConfig = { networking.hostName = hostName; };

    in nixpkgs.lib.nixosSystem {
      modules = systemConfig ++ [ hardwareProfile hostnameConfig home-manager.nixosModules.home-manager hmModules ];
      specialArgs = {
        inherit inputs;    # Share access to the flake inputs in the configuration.
        libm32 = self.lib; # Make this library available in the configuration.
      };
    };

  /* Helper to perform makeSystemConfiguration on an attrset of multiple hosts */
  makeSystemConfigurations = hosts:
    builtins.mapAttrs (hostName: hostConfig: self.lib.system.makeSystemConfiguration (hostConfig // { inherit hostName; })) hosts;
}
