{ self, inputs, ... }:
let
  inherit (inputs) nixpkgs sops-nix disko lanzaboote emacs-overlay;
in {
  flake.nixosModules = {
    # Modules common to all configuration profiles
    common = { pkgs, ... }: {
      imports = [
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote

        self.nixosModules.home-manager
        self.nixosModules.secrets

        ./auto-upgrade.nix
        ./nix.nix
        ./packages.nix
        ./registry.nix
        ./system.nix

        ./networking
        ./security
        ./users
      ];

      # Nixpkgs
      nixpkgs.overlays = [ emacs-overlay.overlay ];
    };

    # Modules common to a workstation
    workstation = { ... }: {
      imports = [
        self.nixosModules.common

        ./backup
        ./desktop

        ./devices/iphone.nix
        ./devices/printers.nix
        ./devices/sdr.nix
        ./security/firejail.nix
        ./virtualisation/containers.nix
      ];

      # Home-manager users
      home-manager.users.m32 = nixpkgs.lib.mkDefault self.homeModules.desktop;

      # Backups
      backups.srv.enable = true;
      backups.home.enable = true;
      backups.podman.enable = true;

      # Console
      console.earlySetup = true;

      # Networking
      networking.networkmanager.enable = true;

      time.timeZone = nixpkgs.lib.mkDefault "America/Denver";
    };

    # Modules common to a server
    server = { ... }: {
      imports = [
        self.nixosModules.common

        ./backup

        ./web/letsencrypt.nix
        ./web/nginx.nix
        ./security/sshd.nix
        ./virtualisation/containers.nix
      ];

      # Home-manager users
      home-manager.users.m32 = nixpkgs.lib.mkDefault self.homeModules.default;

      # Backups
      backups.srv.enable = true;
    };

    # Module for handling secrets
    secrets = { pkgs, config, lib, ... }:
      let
        sopsFile = ../hosts/. + "/${config.networking.hostName}.yml";
      in {
        imports = [ sops-nix.nixosModules.sops ];

        sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

        sops.defaultSopsFile = lib.mkIf (builtins.pathExists sopsFile) sopsFile;
        sops.defaultSopsFormat = "yaml";

        # -- BACKUP --
        sops.secrets."backup_repo/repository" = lib.mkIf (builtins.hasAttr "backups" config) {
          sopsFile = ../secrets/backup.yml;
          format = "yaml";
        };
        sops.secrets."backup_repo/connection" = lib.mkIf (builtins.hasAttr "backups" config) {
          sopsFile = ../secrets/backup.yml;
          format = "yaml";
        };
        sops.secrets."backup_repo/password" = lib.mkIf (builtins.hasAttr "backups" config) {
          sopsFile = ../secrets/backup.yml;
          format = "yaml";
        };
        sops.secrets."backup_repo/ssh_id" = lib.mkIf (builtins.hasAttr "backups" config) {
          sopsFile = ../secrets/backup.yml;
          format = "yaml";
        };
        sops.secrets."backup_repo/known_hosts" = lib.mkIf (builtins.hasAttr "backups" config) {
          sopsFile = ../secrets/backup.yml;
          format = "yaml";
        };

        # -- DEPLOYMENT --

        # public ssh deploy key for repo
        sops.secrets."deploy/deploy_pub" = {
          sopsFile = ../secrets/deploy.yml;
          format = "yaml";
        };
        # private ssh deploy key for repo
        sops.secrets."deploy/deploy_private" = {
          sopsFile = ../secrets/deploy.yml;
          format = "yaml";
        };
        # authorized keys file for repo
        sops.secrets."deploy/authorized_keys" = {
          sopsFile = ../secrets/deploy.yml;
          format = "yaml";
        };
      };

    backup = { ... } : {
      imports = [ ./backup ];
    };
  };
}
