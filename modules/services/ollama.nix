{ config, lib, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = if config.hardware.nvidia.open then false else "cuda";
  };
}
