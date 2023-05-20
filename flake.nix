{
  description = "git.m32.me/conf/m32.conf - configuration for my systems";

  inputs = {
    # Primary Package Repos
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";

    # Nix Utilities/Libraries
    flake-utils.url = "github:numtide/flake-utils";

    # Tools / Ops Utilities
    deploy.url = "github:serokell/deploy-rs";

  };

  outputs = inputs@{ self, nixpkgs, home-manager, deploy, nur, flake-utils }:
    let
      # - Local imports --
      util = import ./lib { inherit inputs; };

      # - System Configurations

      # Users / Home Conf --
      users.m32 = import ./config/home.nix;

      # Host Composition --
      hosts =
        { # ** Hosts
          # Desktop
          phoenix =
            { hardwareProfile = ./hardware/phoenix;
              systemConfig =
                [ # Bootloader and Disks specific to this system
                  ./system/boot/uefi.nix

                  # Repos
                  nur.nixosModules.nur

                  # More userlandish profile
                  ./system/october.nix

                  # Others
                  ./system/X/remap_mac_keys.nix

                ];
              users = users;
              deployUser = "m32";
            };

          # T430 laptop
          momentum =
            { hardwareProfile = ./hardware/momentum;
              systemConfig =
                [ # Bootloader
                  ./system/boot/legacyboot.nix

                  # Repos
                  nur.nixosModules.nur

                  # Same shit, different story
                  ./system/october.nix

                  # Need to find a way TODO this on a per keeb basis
                  ./system/X/remap_mac_keys.nix
                ];
              users = users;
              deployUser = "m32";
            };

          # Server
          maple =
            { hardwareProfile = ./hardware/maple;
              systemConfig =
                [ ./system/server.nix
                ];
              deployUser = "m32";
            };

        };
    in {

      # - NixOS Configurations
      nixosConfigurations = util.makeSystemConfigurations hosts;

      # - DevShells
      devShells = {
      };

      # - deploy-rs outputs
      deploy.nodes = util.deploy.makeDeployNodes hosts self.nixosConfigurations;

      # - Lib outputs
      lib = util;
    };

  # Nix Con
}
