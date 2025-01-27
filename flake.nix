{
  description = "m32-conf - configuration for various workstations and servers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager";

    flake-parts.url = "github:hercules-ci/flake-parts";
    sops-nix.url = "github:Mic92/sops-nix";

    # Deployment / Provisioning
    disko.url = "github:nix-community/disko";
    deploy.url = "github:serokell/deploy-rs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-anywhere.url = "github:nix-community/nixos-anywhere/pxe-boot";

    # System Utils
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote.url = "github:nix-community/lanzaboote";

    # Emacs
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };

    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };

    # Extra packages
    l5p-keyboard-rgb.url = "github:4JX/L5P-Keyboard-RGB";

    lan-mouse.url = "github:feschber/lan-mouse";
  };

  outputs = inputs@{ self, flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        ./configurations.nix
        ./home/flake-module.nix
        ./devShells/flake-module.nix
        ./modules/flake-module.nix
        ./pkgs/flake-module.nix
      ];
    };
}
