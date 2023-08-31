{
  description = "Coherent configurations for systems - m32.conf";

  inputs = {
    # Primary Package Repos
    nixpkgs.url      = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur.url          = "github:nix-community/NUR";

    # Nix Utilities/Libraries
    flake-utils.url  = "github:numtide/flake-utils";
    sops-nix.url     = "github:Mic92/sops-nix";

    # Tools / Ops
    nixos-generators.url = "github:nix-community/nixos-generators"; # Unused

    # System Utils
    impermanence.url = "github:nix-community/impermanence"; # Unused
    lanzaboote.url   = "github:nix-community/lanzaboote"; # Unused

    # Other
    spacemacs = {
      url = "github:syl20bnr/spacemacs/develop";
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-utils, ... }: flake-utils.lib.meld inputs [ ./pkgs ./config ./lib ./modules ];
}
