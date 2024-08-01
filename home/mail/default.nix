{ config, lib, ... }:
let
  cfg = config.mail;
in {
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
