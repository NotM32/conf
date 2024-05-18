{ pkgs, ... }: {

  imports = [ ./default.nix ./sddm.nix ];

  # Enable the Plasma 6 Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  services.xserver.displayManager.defaultSession = "plasma";

  environment.plasma6.excludePackages = with pkgs.libsForQt5; [ konsole elisa ];

  environment.systemPackages = with pkgs; [ kleopatra ];
}
