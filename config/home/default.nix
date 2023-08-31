{ ... }:
let
  # Directory Configuration
  userConfig = ./user.nix;
  layersDir = ./layers;

  # Profiles -
  profiles = rec {
    all = [ "base" "development" "editors" "security" "web" "workstation" ];
    full = all;
    server = [ "base" "security" ];
  };
in {
  conf.home = {
    inherit userConfig;

    profiles = builtins.mapAttrs (name: comp:
      (builtins.map (layer: import "${layersDir}/${layer}.nix") comp))
      profiles;
  };
}
