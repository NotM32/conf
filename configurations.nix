{ self, ... }:
let
  inherit (self.inputs) nixpkgs nur home-manager sops-nix disko lanzaboote flake-registry emacs-overlay;
  nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;

  commonModules = [
    # make flake 'self' and 'inputs' attributes available to configuration modules
    { _module.args = { inherit self; } // self.inputs; }

    disko.nixosModules.disko
    sops-nix.nixosModules.sops
    lanzaboote.nixosModules.lanzaboote

    self.nixosModules.home-manager

    ({ pkgs, config, lib, ... }:
      let
        # host specific secrets file
        sopsFile = ./. + "hosts/${config.networking.hostName}.yml";
      in {
        nixpkgs.overlays = [ emacs-overlay.overlay ];

        nix.nixPath = [
          "nixpkgs=${pkgs.path}"
          "nur=${nur}"
          "home-manager=${home-manager}"
        ];

        nix.extraOptions = ''
          flake-registry = ${flake-registry}/flake-registry.json
        '';

        nix.registry = {
          home-manager.flake = home-manager;
          nixpkgs.flake = nixpkgs;
          nur.flake = nur;
        };

        sops.secrets = lib.mkIf (builtins.pathExists sopsFile) sopsFile;

        time.timeZone = lib.mkDefault "America/Denver";
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

    ./modules/desktop
    ./modules/backup
    ./modules/virtualisation/containers.nix
    ./modules/virtualisation/libvirtd.nix

    ./modules/devices/printers.nix
    ./modules/devices/sdr.nix

    { console.earlySetup = true;
      networking.networkmanager.enable = true;
    }
  ];

  serverModules = [ { home-manager.users.m32 = self.homeModules.default; }
                    { networking.domain = "m32.io"; }

                    ./modules/backup
                    { backups.srv.enable = true; }

                    ./modules/virtualisation/containers.nix
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

    nova = nixosSystem {
      modules = commonModules ++ workstationModules ++ [ ./hosts/nova.nix ];
    };
  };
}
