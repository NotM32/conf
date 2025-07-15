{ config, lib, ... }:
let
  # If we define this host in nix.buildMachines, enable the distributed builder user config
  enableRemoteBuildUser = (
    builtins.any (machine: config.networking.hostName == machine.hostName) config.nix.buildMachines
  );
in
{
  imports = [ ./m32.nix ];

  # User for distributed builds
  users.users."remotebuilder" = lib.mkIf enableRemoteBuildUser {
    isNormalUser = true;
    createhome = false;
    group = config.users.groups."remotebuilder".name;

    openssh.authorizedKeys.keyFiles = [
      config.sops.secrets."remote_builds/authorized_keys".path
    ];
  };

  users.groups."remotebuilder" = lib.mkIf enableRemoteBuildUser {

  };
}
