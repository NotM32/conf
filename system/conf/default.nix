{ ... }:
{
  # Timer to automatically pull this repo locally. Not using ATM
  systemd.timers.sync-conf-repo = {
    enable = false;
    description = "Periodically sync the /srv/conf/ git repo with upstream. This is used to configure this system.";
    after = "network.target";
    timerConfig = {
      OnCalendar = "1h";
    };
    unitConfig = {
      ConditionDirectoryNotEmpty = "/srv/conf/";
    };
  };

  # Configure NixOS autoupgrades.
  system.autoUpgrade = {
    enable = true;
    persistent = true;
    operation = "switch";
    flake = "git://https://git.m32.me/conf/m32.nix?ref=prod#${networking.hostname}";
    dates = "daily";
  };
}
