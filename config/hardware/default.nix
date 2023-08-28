{ nixpkgs, ... }:
{
  conf.hardware = builtins.mapAttrs (name: value: import value) (nixpkgs.lib.attrsets.filterAttrs (name: value: value == "regular") (builtins.readDir ./.));

}
