{ self, config, lib, pkgs, nur, home-manager, flake-registry, nixpkgs, ... }:
with lib; {
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

  nix.nixPath =
    [ "nixpkgs=${pkgs.path}" "nur=${nur}" "home-manager=${home-manager}" ];

  nix.extraOptions = ''
    flake-registry = ${flake-registry}/flake-registry.json
  '';

  nix.registry = {
    self.flake = self;
    self-latest = {
      from = {
        id = "self-latest";
        type = "indirect";
      };
      to = {
        type = "github";
        owner = "NotM32";
        repo = "conf";
      };
    };
    home-manager.flake = home-manager;
    nixpkgs.flake = nixpkgs;
    nur.flake = nur;
  };

  # The below generates a list of build hosts from the hosts in this flake
  nix.buildMachines = let
    maxJobs = 4;
    speedFactor = 2; # TODO: document this per host
  in attrsets.mapAttrsToList (hostName: cfg: {
    inherit hostName maxJobs speedFactor;
    # Support the hostPlatform and any emulated systems
    systems = [ cfg.config.nixpkgs.hostPlatform.system ]
      ++ cfg.config.boot.binfmt.emulatedSystems;
    # Support teh features from that machine's own configurations
    supportedFeatures = cfg.config.nix.settings.system-features;
  }) (attrsets.filterAttrs (n: v:
    n
    != config.networking.hostName) # Filter out the same host, TODO: exclude certain hosts
    self.nixosConfigurations);
  nix.distributedBuilds = true;

}
