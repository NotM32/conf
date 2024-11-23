{ lib, config, ... }:
with lib;
let
  repoConfig = {
    repositoryFile = config.sops.secrets."backup_repo/repository".path;
    passwordFile = config.sops.secrets."backup_repo/password".path;
    initialize = false;

    extraOptions = [
      ''sftp.command="/bin/sh -c 'ssh $(cat ${config.sops.secrets."backup_repo/connection".path}) -i ${config.sops.secrets."backup_repo/ssh_id".path} -o UserKnownHostsFile=${config.sops.secrets."backup_repo/known_hosts".path} -s sftp'" ''
    ];
  };
in {
  options = {
    backups = {
      home.enable = mkOption {
        description = "Backup user home directories";
        type = types.bool;
        default = false;
        example = true;
      };

      srv.enable = mkOption {
        description = "Backup server data directories";
        type = types.bool;
        default = true;
        example = true;
      };

      podman.enable = mkOption {
        description = "Backup user podman data";
        type = types.bool;
        default = false;
        example = true;
      };
    };
  };

  config = {
    services.restic.backups = {
      # Server data
      srv = repoConfig // {
        paths = [ "/srv/" ];

        extraBackupArgs = [ "--option read-concurrency=10" "--tag automatic" ];

        timerConfig = {
          OnCalendar = "01,04,07,10,13,16,19,22:00:00";
          RandomizedDelaySec = "15m";
        };
      };

      # * General backup of home directory hosts.
      home = mkIf (config.backups.home.enable) (repoConfig // {
        paths = [
          "/home/m32/media"
          "/home/m32/docs"
          "/home/m32/downloads"
          "/home/m32/projects"
        ];
        exclude = [ "/home/m32/games/*" ];

        extraBackupArgs = [ "--option read-concurrency=10" "--tag automatic" "--tag home" ];

        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
          RandomizedDelaySec = "15m";
        };

        createWrapper = false;
      });

      homeFull = mkIf (config.backups.home.enable) (repoConfig // {
        paths = [
          "/home/m32"
        ];
        exclude = [ "/home/m32/games/*" ];

        extraBackupArgs = [ "--option read-concurrency=10" "--tag automatic" "--tag home" "--tag full" ];

        timerConfig = {
          OnCalendar = "00,12:00:00";
          Persistent = true;
          RandomizedDelaySec = "15m";
        };

        createWrapper = false;
      });
    };
  };
}
