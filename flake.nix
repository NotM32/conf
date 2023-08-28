{
  description = "git.m32.me/conf/m32.conf - configuration for my systems";

  inputs = {
    # Primary Package Repos
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";

    # Nix Utilities/Libraries
    flake-utils.url = "github:numtide/flake-utils";                  # flake-utils
    sops-nix.url = "github:Mic92/sops-nix";                          # for secrets management

    # Tools / Ops Utilities
    nixos-generators.url = "github:nix-community/nixos-generators";  # Unused

    # System Utils
    impermanence.url = "github:nix-community/impermanence";          # Unused, but when I have free time
    lanzaboote.url = "github:nix-community/lanzaboote";              # Unused, waiting for development to progress

  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, flake-utils, impermanence, lanzaboote, nixos-generators, sops-nix, ... }:
    let
      # - Local imports --
      libconf = import ./lib inputs;

      # Users / Home Conf --
      users.m32 = import ./config/home.nix;

      # Host Composition --
      hosts =
        { # ** Hosts
          # Desktop
          phoenix =
            { hardwareProfile = ./hardware/ryzen_desktop.nix;
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
            };

          # T430 laptop
          momentum =
            { hardwareProfile = ./hardware/t430.nix;
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
            };

          # Server
          maple =
            { hardwareProfile = ./hardware/ovh_vps.nix;
              systemConfig =
                [ ./system/server.nix
                ];
            };

        };
    in {
      # - NixOS Configurations
      nixosConfigurations = libconf.system.makeSystemConfigurations hosts;

      # - Lib outputs
      lib = libconf;
    };
}
