{ self, inputs, ... }:
let inherit (inputs) home-manager emacs-overlay;
in {
  perSystem = { pkgs, ... }: {
    legacyPackages.homeConfigurations = {
      "default" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit self; } // inputs;

        modules = [ self.homeModules.default ];
      };
      "desktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit self; } // inputs;

        modules = [ self.homeModules.desktop ];
      };
    };
  };

  flake.homeModules = {
    # * configuration sets
    default = import ./default.nix;     # no gui or development stuff, just shell and utils
    desktop = import ./desktop;         # desktop environment full setup
    development = import ./development; # just development stuff

    # * individual applications
    alacritty = import ./alacritty;
    emacs = {
      nixpkgs.overlays = [ emacs-overlay.overlay ];
      imports = [ ./emacs ];
    };
    firefox = import ./firefox;
    git = import ./development/git.nix;
    gpg = import ./gpg;
    hyprland = import ./hyprland;
    mail = import ./mail;
    nushell = import ./nushell;
    ssh = import ./ssh;
    vscode = import ./development/vscode.nix;

    # A custom module for handling protonmail-bridge
    proton-mail-bridge = import ./mail/protonmail-bridge.nix;
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
