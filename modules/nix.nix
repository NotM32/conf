{ pkgs, nur, home-manager, flake-registry, nixpkgs, self, ... }: {
  nix.settings = {
    system-features = [ "recursive-nix" "kvm" "nixos-test" "big-parallel" ];
    experimental-features = [ "nix-command" "flakes" "recursive-nix" ];
    trusted-users = [ "root" "m32" ];
  };

  nix.gc = {
    automatic = true;
    dates = "08:00";
    options = "--delete-older-than 3d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "daily" ];
  };

  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
    "nur=${nur}"
    "home-manager=${home-manager}"
  ];

  nix.extraOptions = ''
        flake-registry = ${flake-registry}/flake-registry.json
                     '';

  nix.registry = {
    self.flake = self;
    home-manager.flake = home-manager;
    nixpkgs.flake = nixpkgs;
    nur.flake = nur;
  };
}
