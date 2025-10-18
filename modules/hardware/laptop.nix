{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ powertop ];

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
  };

  services.tlp.enable = true;

  # Systemd targets for line power / battery power changes
  systemd.targets = {
    ac = {
      description = "AC Power Online";
      unitConfig.DefaultDependencies = "no";
    };
  };

  # Udev rules to trigger above systemd targets
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="ACAD", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start ac.target"
    SUBSYSTEM=="power_supply", KERNEL=="ACAD", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl stop ac.target"
  '';
}
