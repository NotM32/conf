{ ... }:
{
  imports =
    [ ./global.nix
      ./server/ssh.nix
      ./server/letsencrypt.nix
      ./server/gitea.nix
      ./server/backups.nix
      ./server/nginx.nix
      ./network/zerotier.nix
    ];

  # Enable use of sudo if SSH agent provides an authorized key. This removes the need for passwords.
  security.pam.enableSSHAgentAuth = true;
}
