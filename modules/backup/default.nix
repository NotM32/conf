{ pkgs, lib, config, ... }: {
  options = {
    backups = {
      home.enable = lib.mkOption {
        description = "Backup user home directories";
        type = lib.types.bool;
        default = false;
        example = true;
      };

      srv.enable = lib.mkOption {
        description = "Backup user home directories";
        type = lib.types.bool;
        default = true;
        example = true;
      };

      podman.enable = lib.mkOption {
        description = "Backup user podman data";
        type = lib.types.bool;
        default = false;
        example = true;
      };
    };
  };

  config = {
    services.restic.backups = rec {
      # 
      rsyncnet = {
        repository = "sftp:fm1383@fm1383.rsync.net:backups/srv/";
        passwordFile = "/etc/nixos/secrets/r_pass";
        initialize = false;

        paths = [ "/srv/" ];

        extraOptions = [
          "sftp.command='ssh fm1383@fm1383.rsync.net -i /etc/nixos/secrets/id_backup -s sftp'"
        ];

        extraBackupArgs = [ "--option read-concurrency=10" "--tag automatic" ];

        timerConfig = {
          OnCalendar = "01,04,07,10,13,16,19,22:00:00";
          RandomizedDelaySec = "15m";
        };
      };

      # * General backup of home directory hosts.
      home = lib.mkIf (config.backups.home.enable) rsyncnet // {
        paths = [
          "/home/m32/media"
          "/home/m32/docs"
          "/home/m32/downloads"
          "/home/m32/projects"
        ];
        exclude = [ "/home/m32/games/*" ];

        extraOptions = [
          "sftp.command='ssh fm1383@fm1383.rsync.net -i /home/m32/.ssh/id_rsa -o UserKnownHostsFile=/home/m32/.ssh/known_hosts -s sftp'"
        ];

        timerConfig = {
          OnCalendar = "00,04,08,12,16,20:00:00";
          RandomizedDelaySec = "15m";
        };

        createWrapper = false;
      };

      # This backup instance is required if storing podman dev container data in the home directory
      # the above configuration should be setup not to fail when the backup system can't access a file.
      podman = lib.mkIf (config.backups.home.enable) rsyncnet // {
        # Create a wrapper package that uses the podman unshare thing
        package = pkgs.writeShellScriptBin "restic" ''
          # Call restic within podman unsahre
          exec ${pkgs.podman}/bin/podman unshare ${pkgs.restic}/bin/restic "$@"
        '';
        paths = [ ];
        dynamicFilesFrom =
          "find /home/m32 -type d ! -readable -a ! -executable -a ! -user m32 -print 2>/dev/null; exit 0;";
        extraBackupArgs = home.extraBackupArgs ++ [ "--tag podman" ];

        createWrapper = false;
      };
    };
  };
}
