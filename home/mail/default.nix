{ config, lib, ... }:
let
  cfg = config.mail;
in {
  options = {
    mbSync.enable = lib.mkEnableOption "enable mbsync for mail sync";
  };

  config = {
    services.mbsync = lib.mkIf cfg.mbsync.enable {
      enable = true;
      preExec = "mkdir -p ~/mail/protonmail/";
      configFile = ./mbsyncrc;
    };
  };
}
