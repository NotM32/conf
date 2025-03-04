{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.allowUnfreePackages;
in {
  options = {
    allowUnfreePackages = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "List of unfree packages allowed to be installed. Supports regex matching";
      example = lib.literalExpression ''[ "steam" "nvidia-.* ]'';
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      vim
      wget
      unzip
      lm_sensors
      cachix
    ];

    allowUnfreePackages = [
        "steam"
        "steam-.*"
        "obsidian"
        "spotify"
        "pycharm-community"
        "terraform" # TODO: Use OpenTofu or migrate all HCL I've written to Pulumi
        "zerotierone"
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0" # EOL, required for Obsidian
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      let
        pkgName = (lib.getName pkg);
        matchPackges = (reg: !builtins.isNull (builtins.match reg pkgName));
      in builtins.any matchPackges cfg;
  };
}
