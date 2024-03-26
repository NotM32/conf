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
    nixos-anywhere.url = "github:nix-community/nixos-anywhere/pxe-boot";

    # System Utils
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote.url = "github:nix-community/lanzaboote";

    # Spacemacs
    spacemacs = {
      url = "github:syl20bnr/spacemacs";
      flake = false;
    };

    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

      imports = [
        ./configurations.nix
        ./home/flake-module.nix
        ./devShells/flake-module.nix
        ./modules/flake-module.nix
        ./pkgs/flake-module.nix
      ];
    };


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
