{ config, lib, ... }:
with lib;
let
  cfg = config.disks.unlocking;
in {
  options.disks.unlocking = {
    enableSSH = mkEnableOption "initrd ssh disk unlocking";
  };

  config = {
    boot.initrd = mkIf cfg.enableSSH {
      systemd.users.root.shell = "/bin/cryptsetup-askpass";
      network = {
        enable = true;
        ssh = {
          enable = true;
          hostKeys = [ "${config.ephemeral.persistPath}/etc/ssh/ssh_host_ed25519_key" ];
          authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        };
      };
    };
  };
}
