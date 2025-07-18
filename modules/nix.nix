{
  self,
  config,
  lib,
  pkgs,
  home-manager,
  flake-registry,
  nixpkgs,
  ...
}:
with lib;
{
  nix.settings = {
    system-features = [
      "recursive-nix"
      "kvm"
      "nixos-test"
      "big-parallel"
    ];

    experimental-features = [
      "nix-command"
      "flakes"
      "recursive-nix"
    ];

    trusted-users = [
      "root"
      "m32"
    ];
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
    "home-manager=${home-manager}"
  ];

  nix.extraOptions = ''
    flake-registry = ${flake-registry}/flake-registry.json
  '';

  nix.registry = {
    # a version that follows the latest changes from the repository
    self = {
      from = {
        id = "self";
        type = "indirect";
      };

      to = {
        type = "github";
        owner = "NotM32";
        repo = "conf";
      };
    };
    # a pinned version of this flake
    self-active.flake = self;
    home-manager.flake = home-manager;
    nixpkgs.flake = nixpkgs;
  };

  # The below generates a list of build hosts from the hosts in this flake
  nix.buildMachines =
    attrsets.mapAttrsToList
      (hostName: cfg: {
        inherit hostName;
        maxJobs = 4;
        speedFactor = 2; # TODO: document this per host
        # Support the hostPlatform and any emulated systems
        systems = [ cfg.config.nixpkgs.hostPlatform.system ] ++ cfg.config.boot.binfmt.emulatedSystems;
        # Support the features from that machine's own configurations
        supportedFeatures = cfg.config.nix.settings.system-features;
        sshKey = config.sops.secrets."remote_builds/ssh_private_key".path or "";
      })
      (
        attrsets.filterAttrs (n: v: n != config.networking.hostName) # Filter out the same host, TODO: exclude certain hosts
          self.nixosConfigurations
      );
  nix.distributedBuilds = true;
}
