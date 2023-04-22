{ config, ... }:
{
  services.restic.backups = {
    rsyncnet = {
      passwordFile = "/etc/nixos/secrets/r_pass";
      initialize = false;
      paths = [
        "/srv/"
      ];
      repository = "sftp:fm1383@fm1383.rsync.net:backups/srv/";
      extraOptions = [
        "sftp.command='ssh fm1383@fm1383.rsync.net -i /etc/nixos/secrets/id_backup -s sftp'"
      ];
      timerConfig = {
        OnCalendar = "12h";
        RandomizedDelaySec = "1h";
      };
    };
  };
}
