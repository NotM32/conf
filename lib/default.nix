inputs@{ ... }:
let
  # Local Imports
  deploy = import ./deploy.nix { inherit inputs; };
  system = import ./system.nix inputs;
in
{
  inherit deploy system;
}
