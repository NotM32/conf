{ self, inputs, ... }:
let
  inherit (inputs) home-manager;
in {
  perSystem = { pkgs, ... }: {
    legacyPackages.homeConfigurations = {
      "m32" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];
      };
    };
  };

  flake.homeModules = {
    default = { ... }: {
      imports = [ ./default.nix ];
    };
    desktop = { ... }: {
      imports = [ ./default.nix ./home.nix ];
    };
  };
}
