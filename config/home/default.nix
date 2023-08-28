inputs@{ ... }:
let
  userConfig = ./user.nix;
  moduleDir = ./modules;

  profiles = import ./profiles inputs;
in {
  conf.home = {
    # map profile attrset, map the list to convert relative names to full path and yea
  };
}
