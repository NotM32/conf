{ config, pkgs, ... }:

{
  options = {
    security.pam.sshAgentAuth.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable SSH Agent Authentication for PAM.";
    };
  };

  config = {
    # Update the option name to the new one
    security.pam.sshAgentAuth.enable = true;
  };
}