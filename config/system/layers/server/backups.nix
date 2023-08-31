{ ... }:
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
        OnCalendar = "01,04,07,10,13,16,19,22:00:00";
        RandomizedDelaySec = "15m";
      };
    };
  };
}
