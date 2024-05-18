{ self, ... }:
let
  inherit (self.inputs) nixpkgs nur home-manager sops-nix disko flake-registry;
  nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;

  commonModules = [
    { _module.args = { inherit self; } // self.inputs; }

    disko.nixosModules.disko
    sops-nix.nixosModules.sops
    self.nixosModules.home-manager

    ({ pkgs, config, lib, ... }:
      let sopsFile = ./. + "hosts/${config.networking.hostName}.yml";
      in {
        nix.nixPath = [
          "nixpkgs=${pkgs.path}"
          "nur=${nur}"
          "home-manager=${home-manager}"
        ];

        sops.secrets = lib.mkIf (builtins.pathExists sopsFile) sopsFile;

        nix.extraOptions = ''
          flake-registry = ${flake-registry}/flake-registry.json
        '';

        nix.registry = {
          home-manager.flake = home-manager;
          nixpkgs.flake = nixpkgs;
          nur.flake = nur;
          #TODO: mur
        };

        time.timeZone = "America/Denver";
      })

    ./modules/nix.nix
    ./modules/packages.nix
    ./modules/auto-upgrade.nix
    ./modules/registry.nix
    ./modules/system.nix
    ./modules/networking
    ./modules/security
    ./modules/users
  ];

  workstationModules = [
    { home-manager.users.m32 = nixpkgs.lib.mkDefault self.homeModules.desktop; }

    ./modules/backup
    { backups.srv.enable = true; }
    { backups.home.enable = true; }
    { backups.podman.enable = true; }

    ./modules/workstation.nix
    ./modules/desktop
    ./modules/containers.nix
  ];

  serverModules = [ { home-manager.users.m32 = self.homeModules.default; }
                    { networking.domain = "cubit.sh"; }

                    ./modules/backup
                    { backups.srv.enable = true; }

                    ./modules/containers.nix
                    ./modules/web/nginx.nix
                    ./modules/web/letsencrypt.nix
                    ./modules/sshd.nix
                  ];

in {
  flake.nixosConfigurations = {
    phoenix = nixosSystem {
      modules = commonModules ++ workstationModules ++ [ ./hosts/phoenix.nix ];
    };

    momentum = nixosSystem {
      modules = commonModules ++ workstationModules ++ [ ./hosts/momentum.nix ];
    };

    maple = nixosSystem {
      modules = commonModules ++ serverModules ++ [ ./hosts/maple.nix ];
    };
  };
}
