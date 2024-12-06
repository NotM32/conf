{ config, lib, pkgs,  ... }:
let
  cfg = config.mail;
in {
  home.packages = [ pkgs.protonmail-bridge ];

  options.mail = {
    mbSync.enable = lib.mkEnableOption "enable mbsync for mail sync";
  };

  config = {
    services.mbsync = lib.mkIf cfg.mbSync.enable {
      enable = true;
      preExec = "mkdir -p ~/mail/protonmail/";
      configFile = ./mbsyncrc;
    };
  };
}
