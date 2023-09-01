inputs@{ ... }:
let
  layersPath = ./layers;
  rolesPath = ./roles;
in {
  conf.system = {
    inherit layersPath rolesPath;

    roles = import rolesPath;
    layers = import layersPath inputs;
  };
}
