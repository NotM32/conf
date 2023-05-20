# No-bullshit, simple utility function for creating dynamic, composable
# multi-system configurations.

{ inputs, ... }:
let
  # Flake
  pkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;

  # Local Imports
  deploy = import ./deploy.nix { inherit inputs; };
in
rec {
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
    in pkgs.lib.nixosSystem {
      modules = systemConfig ++ [ hardwareProfile hostnameConfig home-manager.nixosModules.home-manager hmModules ];
      # Give us access to flake inputs by providing it as an argument to the configuration module calls
      specialArgs = {
        inherit inputs;
      };
    };

  /* Helper to perform makeSystemConfiguration on an attrset of multiple hosts */
  makeSystemConfigurations = hosts:
    builtins.mapAttrs (hostName: hostConfig: makeSystemConfiguration (hostConfig // { inherit hostName; })) hosts;

  # Add other library modules here so they can be imported with 'import default'
  inherit deploy;
}
