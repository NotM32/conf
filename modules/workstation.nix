{ pkgs, ... }: {
  console.earlySetup = true;

  # Networking
  networking.networkmanager.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ cups-dymo epson-escpr ];
  hardware.sane.enable = true;

  # Other
  hardware.hackrf.enable = true;
  hardware.rtl-sdr.enable = true;

  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
}
