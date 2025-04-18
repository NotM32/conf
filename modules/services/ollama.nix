{ config, lib, pkgs, ... }:

{
  allowUnfreePackages = [
    "cuda.*"
    "libcublas"
  ];

  services.ollama = {
    enable = true;
    acceleration = if (config.hardware.nvidia.enabled && !config.hardware.nvidia.open) then "cuda" else false;
  };
}
