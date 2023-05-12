# No-bullshit, simple utility function for creating dynamic, composable
# multi-system configurations.

{ inputs, ... }:
let
  # Flake
  flake = ../flake.nix;
  pkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;

  # Local Imports
  deploy = import ./deploy.nix { inherit inputs; };
in
rec {
  inherit deploy;

  # Make one configuration
  makeSystemConfiguration = { hardwareConfig,
                              systemConfig,
                              hmConfig ? { },
                              hmUsers ? { },
                              system ? "x86_64-linux",
                              hostName ? "nixos",
                              ... }@args:
    let
      hmModules =
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users = hmUsers;
        } // hmConfig;

      hostnameConfig =
        {
          networking.hostName = hostName;
          # system.nixos.label = "";

        };
    in
    pkgs.lib.nixosSystem {
      system = system;
      modules =
        # System Configurations
        hardwareConfig ++
        systemConfig ++
        [
          hostnameConfig
          # Home Manager
          home-manager.nixosModules.home-manager
          hmModules
        ];

      specialArgs = {
        inherit inputs;
      };
    };

  # Make many configurations
  makeSystemConfigurations = hosts:
    builtins.mapAttrs (hostName: hostConfig: makeSystemConfiguration (hostConfig // { inherit hostName; })) hosts;
}
