{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ powertop ];

  services.logind.lidSwitch = "suspend";

  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
  };

  services.tlp = {
    enable = true;
  };
}
