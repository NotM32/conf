{ self, ... }:
let
  inherit (self.inputs) nixpkgs nur home-manager sops-nix disko flake-registry;
  nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;

  commonModules = [
    {
      _module.args = { inherit self; } // self.inputs;
    }

    disko.nixosModules.sops
    ({ pkgs, config, lib, ... }:
      let sopsFile = ./. + "hosts/${config.networking.hostName}.yml";
      in {
        nix.nixPath = [ "nixpkgs=${pkgs.path}" "nur=${nur}" "home-manager=${home-manager}" ];

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

    home-manager.nixosModules.home-manager
    { home-manager.extraSpecialArgs = { inherit self; } // self.inputs;
      home-manager.useGlobalPkgs = true;
    }
  ];

  workstationModules = [
    { home-manager.users.m32 = import ./home/home.nix; }
  ];

  serverModules = [

  ];

in {
  flake.nixosConfigurations = {
    phoenix = nixosSystem {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = commonModules ++ workstationModules ++ [ ./hosts/phoenix.nix ];
    };

    momentum = nixosSystem {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = commonModules ++ workstationModules ++ [ ./hosts/momentum.nix ];
    };

    maple = nixosSystem {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = commonModules ++ workstationModules ++ [ ./hosts/maple.nix ];
    };
  };
}
