{ config, ... }:
{
  services.restic.backups = {
    rsyncnet = {
      passwordFile = "/etc/nixos/secrets/r_pass";
      initialize = false;
      paths = [
        "/srv/"
      ];
      repository = "sftp:fm1383@fm1383.rsync.net:backups/maple/srv/";
      extraOptions = [
        "sftp.command='ssh fm1383@fm1383.rsync.net -i /etc/nixos/secrets/id_backup -s sftp'"
      ];
      timerConfig = {
        OnCalendar = "00:30";
        RandomizedDelaySec = "1h";
      };
    };
  };
}
