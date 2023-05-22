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
    nixos-generators.url = "github:nix-community/nixos-generators";

    # System Utils
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote.url = "github:nix-community/lanzaboote";

  };

  outputs = inputs@{ self, nixpkgs, home-manager, deploy, nur, flake-utils, impermanence, lanzaboote, nixos-generators }:
    with flake-utils.lib; eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system};
    /* Flake outputs not-related to system configuration are in the below attrset */
    in {

      packages = {
        /* Build the documentation book in `docs/` */
        docs = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "m32meconf-docs";
          version = self.lastModifiedDate;
          src = self;

          doCheck = true;

          buildInputs = with pkgs; [ coreutils mdbook ];
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];

          buildPhase = ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            cargo install mdbook-nix-eval
            mdbook build ./docs/
          '';

          installPhase = ''
            mkdir -p $out
            cp -r ./docs/book/* $out
          '';
        };

        /* Things I couldn't find a package for */
        mdbook-nix-eval = pkgs.rustPlatform.buildRustPackage rec {
          pname = "mdbook-nix-eval";
          version = "1.0.1";

          src = pkgs.fetchCrate {
            inherit pname version;
            sha256 = "sha256-u8iiMyveTQVve7XTuYKHfkPS64ygfhQj7Md2EzGImIY";
          };

          cargoDepsName = pname;
          cargoHash = "sha256-4v6stOMSowbtsKuJO09Rd/nmjF+pJj5hq0/Zgs/yZMc=";
        };

      };

    }) // (

    /* System configuration related items  are below this line */
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

      # - deploy-rs outputs
      deploy.nodes = util.deploy.makeDeployNodes hosts self.nixosConfigurations;

      # - Lib outputs
      lib = util;
    });

  # Nix Con
}
