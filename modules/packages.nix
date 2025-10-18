{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption types;
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
    ];

    allowUnfreePackages = [
      "castlabs-electron"
      "steam"
      "steam-.*"
      "spotify"
      "zerotierone"
    ];

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      let
        pkgName = (lib.getName pkg);
        matchPackges = (reg: !builtins.isNull (builtins.match reg pkgName));
      in
      builtins.any matchPackges config.allowUnfreePackages;
  };
}
