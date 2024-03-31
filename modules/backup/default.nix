{ pkgs, ... }:
{
  services.restic.backups = rec {
    /** General backup of home directory hosts. */
    rsyncnethome = {
      user = "m32";
      passwordFile = "/etc/nixos/secrets/r_pass";
      initialize = false;
      paths = [
        "/home/m32/media"
        "/home/m32/docs"
        "/home/m32/downloads"
        "/home/m32/projects"
      ];
      exclude = [
        "/home/m32/games/*"
      ];
      repository = "sftp:fm1383@fm1383.rsync.net:backups/home/";
      extraOptions = [
        "sftp.command='ssh fm1383@fm1383.rsync.net -i /home/m32/.ssh/id_rsa -o UserKnownHostsFile=/home/m32/.ssh/known_hosts -s sftp'"
      ];
      extraBackupArgs = [ "--option read-concurrency=10"
                          "--tag automatic"
                        ];
      timerConfig = {
        OnCalendar = "00,04,08,12,16,20:00:00";
        RandomizedDelaySec = "15m";
      };
    };

    /** This backup instance is required if storing podman dev container data in the home directory
     * the above configuration should be setup not to fail when the backup system can't access a file.
     */
    rsyncnethomepodman = rsyncnethome // {
      # Create a wrapper package that uses the podman unshare thing
      package = pkgs.writeShellScriptBin "restic" ''
              # Call restic within podman unsahre
              exec ${pkgs.podman}/bin/podman unshare ${pkgs.restic}/bin/restic "$@"
      '';
      paths = [];
      dynamicFilesFrom = "find /home/m32 -type d \! -readable -a \! -executable -a \! -user m32 -print 2>/dev/null; exit 0;";
      extraBackupArgs = rsyncnethome.extraBackupArgs ++ [
        "--tag podman"
      ];
    };
  };
}
