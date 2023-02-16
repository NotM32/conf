{ config, pkgs, ... }:
let
  hardware = ./hardware.nix;
  system = ../../system;
in
{
  # Configuration Profile Imports
  imports =
    [ hardware
      system
    ];

  # Basic Host Information
  networking.hostName = "phoenix";

}
