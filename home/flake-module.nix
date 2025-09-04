{ self, inputs, lib, ... }:
let inherit (inputs) home-manager;
in {
  perSystem = { pkgs, ... }: {
    legacyPackages.
      homeConfigurations = {
      "default" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit self; } // inputs;

        modules = [
          self.homeModules.default
          { home.homeDirectory = lib.mkDefault "/home/m32"; }
        ];
      };
      "desktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit self; } // inputs;

        modules = [
          self.homeModules.desktop
          { home.homeDirectory = lib.mkDefault "/home/m32"; }
        ];
      };
    };
  };

  flake.homeModules = {
    # * configuration sets
    default = import ./default.nix; # no desktop apps or development
    desktop = import ./desktop; # desktop environment full setup
    development = import ./development; # just development stuff

    # * individual applications
    alacritty = import ./alacritty;
    emacs = import ./emacs;
    firefox = import ./firefox;
    git = import ./development/git.nix;
    gpg = import ./gpg;
    hyprland = import ./hyprland;
    mail = import ./mail;
    nushell = import ./nushell;
    quickshell = import ./quickshell;
    ssh = import ./ssh;
    stylix = import ./stylix;
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
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
          ];
        })
      ];
    };
  };
}
