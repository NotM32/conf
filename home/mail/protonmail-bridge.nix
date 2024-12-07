{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.protonmail-bridge;
in {
  options = {
    services.protonmail-bridge.enable = mkEnableOption "protonmail-bridge user service";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.protonmail-bridge ];

    systemd.user.services.protonmail-bridge = {
      Unit = {
        Description = "The protonmail-bridge service";
      };
      Service = {
        ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge -n";
        Restart = "always";
        RestartSec = 10;
        Environment = "PATH=${pkgs.protonmail-bridge}/bin";
      };
    };
  };

}
