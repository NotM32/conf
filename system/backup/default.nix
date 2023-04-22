{ config, ... }:
{
  services.restic.backups = {
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
        "sftp.command='ssh fm1383@fm1383.rsync.net -i /home/m32/.ssh/id_rsa -s sftp"
      ];
      extraBackupArgs = [ "--option read-concurrency=10" ];
      timerConfig = {
        OnCalendar = "6h";
        RandomizedDelaySec = "1h";
      };
    };
  };
}
