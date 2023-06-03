inputs@{ ... }:
{
  /* Utilities for deploy-rs */
  deploy = import ./deploy.nix inputs;
  /* Helpers for working with the `nixosConfigurations` flake output */
  system = import ./system.nix inputs;
  /* Extended library for use inside the NixOS configuration files */
  config = import ./config.nix inputs;
}
