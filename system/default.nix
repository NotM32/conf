{ pkgs, lib, config, self, ... }:

{
  time.timeZone = "America/Los_Angeles";

  # System Wide Packages

  # Nix Options

  nixpkgs.hostPlatform = "x86_64-linux";
}
