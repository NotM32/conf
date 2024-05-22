{ self, inputs, ... }:
let
  inherit (inputs) home-manager emacs-overlay;
in {
  perSystem = { pkgs, ... }: {
    legacyPackages.homeConfigurations = {
      "m32" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit self; } // inputs;

        modules = [ self.homeModules.default ];
      };
    };
  };

  flake.homeModules = {
    /** Just basic shell stuff / cli tool */
    default = {
      imports = [ ./default.nix ];
    };

    /** Full workstation suite with graphical tools and development stuff */
    desktop = {
      nixpkgs.overlays = [ emacs-overlay.overlay ];
      imports = [ ./desktop.nix ];
    };

    /** Desktop app configurations with tiling manager config */
    desktop-tiling = {
      nixpkgs.overlays = [ emacs-overlay.overlay ];
      imports = [ ./desktop.nix ./hyprland ];
    };
  };

  flake.nixosModules = {
    home-manager = {
      imports = [
        home-manager.nixosModules.home-manager
        ({
          home-manager.extraSpecialArgs = { inherit self; } // inputs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        })
      ];
    };
  };
}
