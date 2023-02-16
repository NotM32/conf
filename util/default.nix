{ inputs, ... }:
let
  flake = ../flake.nix;
  pkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;
in
{
  makeSystemConfiguration = { hardwareConfig, systemConfig, hmConfig ? {}, hmUsers, system ? "x86_64-linux", ... }@args:
    let
      hmConfig =
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users = hmUsers;
        } // hmConfig;
    in
      pkgs.lib.nixosSystem {
        system = system;
        modules =
          [ hardwareConfig
            systemConfig
            hmConfig
          ];
      };
}
