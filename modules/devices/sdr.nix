{ ... }:
{
  hardware.hackrf.enable = true;
  hardware.rtl-sdr.enable = true;

  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
}
