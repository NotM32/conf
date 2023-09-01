{ ... }:
let
  /* Configuration */
  layersPath = ./layers;
  rolesPath = ./roles;
in {
  conf.system = {
    inherit layersPath rolesPath;
  };
}
