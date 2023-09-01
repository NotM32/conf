{ nixpkgs, ... }:
let
  lib = nixpkgs.lib;
  categories = builtins.attrNames
    (lib.filterAttrs (k: v: v == "directory") builtins.readDir ./.);
in {

}
