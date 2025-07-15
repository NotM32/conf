{
  self,
  config,
  lib,
  ...
}:
let
  sopsFile = "${self}/hosts/${config.networking.hostName}.yml";
in
{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    defaultSopsFile = lib.mkIf (builtins.pathExists sopsFile) sopsFile;
    defaultSopsFormat = "yaml";

    # Backups
    secrets."backup_repo/repository".sopsFile =
      lib.mkIf (builtins.hasAttr "backups" config) ../secrets/backup.yml;
    secrets."backup_repo/connection".sopsFile =
      lib.mkIf (builtins.hasAttr "backups" config) ../secrets/backup.yml;
    secrets."backup_repo/password".sopsFile =
      lib.mkIf (builtins.hasAttr "backups" config) ../secrets/backup.yml;
    secrets."backup_repo/ssh_id".sopsFile =
      lib.mkIf (builtins.hasAttr "backups" config) ../secrets/backup.yml;
    secrets."backup_repo/known_hosts".sopsFile =
      lib.mkIf (builtins.hasAttr "backups" config) ../secrets/backup.yml;

    # Deployment
    # public ssh deploy key for repo
    secrets."deploy/deploy_pub".sopsFile = ../secrets/deploy.yml;
    # private ssh deploy key for repo
    secrets."deploy/deploy_private".sopsFile = ../secrets/deploy.yml;
    # authorized keys file for repo
    secrets."deploy/authorized_keys".sopsFile = ../secrets/deploy.yml;

    # Remote Builds
    secrets."remote_builds/authorized_keys".sopsFile = ../secrets/builds.yml;
    secrets."remote_builds/ssh_private_key" = lib.mkIf (builtins.pathExists sopsFile){ };
  };
}
