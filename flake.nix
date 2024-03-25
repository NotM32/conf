{
  description = "git.m32.me/conf/m32.conf - configuration for my systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";

    flake-parts.url = "github:hercules-ci/flake-parts";
    sops-nix.url = "github:Mic92/sops-nix"; # for secrets management

    # Deployment / Provisioning
    disko.url = "github:nix-community/disko";
    deploy.url = "github:serokell/deploy-rs";
    nixos-generators.url = "github:nix-community/nixos-generators";

    # System Utils
    impermanence.url =
      "github:nix-community/impermanence";
    lanzaboote.url =
      "github:nix-community/lanzaboote";

    # Spacemacs
    spacemacs = {
      url = "github:syl20bnr/spacemacs";
      flake = false;
    };

    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFLake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      imports = [
        ./configurations.nix
        ./devShells/flake-module.nix
        ./pkgs/flake-module.nix
      ];

      perSystem = { self', config, pkgs, system, ... }: {
        packages = {
          docs = pkgs.stdenvNoCC.mkDerivation rec {
            pname = "m32conf-docs";
            version = self'.lastModifiedDate;
            src = self';

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
        };
      };
    };

  # otheroutputs = inputs@{ self, nixpkgs, home-manager, deploy, nur, flake-utils
  #   , impermanence, lanzaboote, nixos-generators, sops-nix, spacemacs }:
  #   with flake-utils.lib;
  #   eachDefaultSystem (system:
  #     let
  #       pkgs = nixpkgs.legacyPackages.${system};
  #       # Flake outputs not-related to system configuration are in the below attrset
  #     in {
  #       packages = {
  #         # Build the documentation book in `docs/`
  #         docs = pkgs.stdenvNoCC.mkDerivation rec {
  #           pname = "m32meconf-docs";
  #           version = self.lastModifiedDate;
  #           src = self;

  #           doCheck = true;

  #           buildInputs = with pkgs; [ coreutils mdbook ];
  #           phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  #           buildPhase = ''
  #             export PATH="${pkgs.lib.makeBinPath buildInputs}";
  #             cargo install mdbook-nix-eval
  #             mdbook build ./docs/
  #           '';

  #           installPhase = ''
  #             mkdir -p $out
  #             cp -r ./docs/book/* $out
  #           '';
  #         };

  #       };

  #       devShell =
  #         pkgs.mkShell {
  #         inputsFrom = builtins.attrValues self.packages.${system};
  #         # packages = with pkgs; [ ];
  #         shellHook = ''
  #           alias devdocs='mdbook serve --port 3025 --open ./docs/'
  #           alias mkdocs='nix build .#docs'
  #           alias nsp='nix search nixpkgs'
  #           alias dh='echo -e "$DEVSHELL_HELP"'

  #           DEVSHELL_HELP="
  #           Devshell Command Glossary
  #           [docs] devdocs       | Start the mdbook watch server
  #                  mkdocs        | Build the docs

  #           [util] nixos-option  | Search for nixos options
  #                  nsp {package} | Search nixpkgs
  #                  dh            | Show this again
  #           "

  #           echo -e "$DEVSHELL_HELP"
  #         '';
  #       };

  #     }) // (

  #       # System configuration related items  are below this line
  #       let
  #         # - Local imports --
  #         util = import ./lib inputs;

  #         # - System Configurations

  #         # Users / Home Conf --
  #         users.m32 = import ./config/home.nix;

  #         # Host Composition --
  #         hosts = { # ** Hosts
  #           # Desktop
  #           phoenix = {
  #             hardwareProfile = ./hardware/phoenix;
  #             systemConfig = [ # Bootloader and Disks specific to this system
  #               ./system/boot/uefi.nix

  #               # Repos
  #               nur.nixosModules.nur

  #               # More userlandish profile
  #               ./system/october.nix

  #               # Others
  #               ./system/X/remap_mac_keys.nix

  #             ];
  #             users = users;
  #             deployUser = "m32";
  #           };

  #           # T430 laptop
  #           momentum = {
  #             hardwareProfile = ./hardware/momentum;
  #             systemConfig = [ # Bootloader
  #               ./system/boot/legacyboot.nix

  #               # Repos
  #               nur.nixosModules.nur

  #               # Same shit, different story
  #               ./system/october.nix

  #               # Need to find a way TODO this on a per keeb basis
  #               ./system/X/remap_mac_keys.nix
  #             ];
  #             users = users;
  #             deployUser = "m32";
  #           };

  #           # Server
  #           maple = {
  #             hardwareProfile = ./hardware/maple;
  #             systemConfig = [ ./system/server.nix ];
  #             deployUser = "m32";
  #           };

  #         };
  #       in {

  #         # - NixOS Configurations
  #         nixosConfigurations = util.system.makeSystemConfigurations hosts;

  #         # - deploy-rs outputs
  #         deploy.nodes =
  #           util.deploy.makeDeployNodes hosts self.nixosConfigurations;

  #         # - Lib outputs
  #         lib = util;
  #       });

  # Nix Con
}
