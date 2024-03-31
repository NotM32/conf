{ pkgs, ... }:
{
  imports =
    [ ./default.nix
      ./server/ssh.nix
      ./server/letsencrypt.nix
      ./gitea
      ./server/backups.nix
      ./server/nginx.nix
      ./network/zerotier.nix
      ./server/containers.nix
    ];

  environment.systemPackages = with pkgs; [
    git
    podman-tui
  ];

  # Enable use of sudo if SSH agent provides an authorized key. This removes the need for passwords.
  security.pam.enableSSHAgentAuth = true;
}
