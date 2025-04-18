{ config, lib, pkgs, ... }:

{
  allowUnfreePackages = [
    "cuda.*"
  ];

  services.ollama = {
    enable = true;
    acceleration = if config.hardware.nvidia.open then false else "cuda";
  };
}
