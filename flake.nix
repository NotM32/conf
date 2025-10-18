{
  description = "m32-conf - configuration for various workstations and servers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Deployment / Provisioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Image generators
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Remote install support on live system
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere/pxe-boot";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secureboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lock a version of the flake registry
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };

    # Desktop
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Extra packages
    l5p-keyboard-rgb = { url = "github:4JX/L5P-Keyboard-RGB"; };
    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-qml-support = {
      url = "git+https://git.outfoxxed.me/outfoxxed/nix-qml-support.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        home-manager.flakeModules.home-manager

        ./configurations.nix
        ./home/flake-module.nix
        ./devShells/flake-module.nix
        ./lib/flake-module.nix
        ./modules/flake-module.nix
        ./pkgs/flake-module.nix
      ];
    };
}
