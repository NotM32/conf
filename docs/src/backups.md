# Backups
Backups are performed on a systemd timer service, calling restic.

## Backups Management
The easiest way to interact with the backup system is to call the
backup command wrapper script directly. This will handle setting
all the necessary environment variables, repository details and
secrets necessary. Ie call `restic-rsyncnethome` for home directory
backup repository on rsync net.

