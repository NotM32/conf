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
  #
in {
  conf.home = builtins.mapAttrs (name: comp: (builtins.map (layer: import "./${layersDir}/${layer}.nix") comp)) profiles;
    # map profile attrset, map the list to convert relative names to full path and yea

}
