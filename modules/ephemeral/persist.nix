{ config, lib, self, ... }:
with lib;
let
  cfg = config.ephemeral;
in {
  options.ephemeral = {
    enable = mkEnableOption "ephemeral state configurations";

    persistPath = mkOption {
      default = "/persist";
      example = "/nix/persist";
      type = types.string;
    };
  };

  config = mkIf cfg.enable {
    # Ephemeral Root - Persistent file declarations
    # machine-id is used by systemd for the journal, if you don't
    # persist this file you won't be able to easily use journalctl to
    # look at journals for previous boots.
    environment.etc."machine-id".source = "${cfg.persistPath}/etc/machine-id";

    # if you want to run an openssh daemon, you may want to store the
    # host keys across reboots
    environment.etc."ssh/ssh_host_rsa_key".source =
      "${cfg.persistPath}/etc/ssh/ssh_host_rsa_key";
    environment.etc."ssh/ssh_host_rsa_key.pub".source =
      "${cfg.persistPath}/etc/ssh/ssh_host_rsa_key.pub";
    environment.etc."ssh/ssh_host_ed25519_key".source =
      "${cfg.persistPath}/etc/ssh/ssh_host_ed25519_key";
    environment.etc."ssh/ssh_host_ed25519_key.pub".source =
      "${cfg.persistPath}/etc/ssh/ssh_host_ed25519_key.pub";

    sops.age.sshKeyPaths = [ "${cfg.persistPath}/etc/ssh/ssh_host_ed25519_key" ];

  };
}
