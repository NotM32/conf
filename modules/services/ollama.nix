{ config, ... }: {
  allowUnfreePackages = [ "cuda.*" "libcublas" ];

  services.ollama = {
    enable = false;
    acceleration =
      if (config.hardware.nvidia.enabled && !config.hardware.nvidia.open) then
        "cuda"
      else
        false;
  };
}
