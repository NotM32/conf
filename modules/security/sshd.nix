{ config, lib, pkgs, ... }:

{
  options = {
    security.pam.sshAgentAuth.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SSH agent authentication via PAM.";
    };
  };

  config = {
    # Updated option name
    security.pam.sshAgentAuth.enable = config.security.pam.sshAgentAuth.enable;
  };
}