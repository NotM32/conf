{ pkgs, ... }: {
  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ cups-dymo epson-escpr ];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.epkowa ];
  allowUnfreePackages = [ "epkowa" ];
}
