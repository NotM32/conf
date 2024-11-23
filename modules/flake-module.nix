{ self, inputs, ... }:
let
  inherit (inputs) nixpkgs sops-nix disko lanzaboote home-manager nur flake-registry emacs-overlay;
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

      # Nix configuration
      nix.nixPath = [
        "nixpkgs=${pkgs.path}"
        "nur=${nur}"
        "home-manager=${home-manager}"
      ];

      nix.extraOptions = ''
        flake-registry = ${flake-registry}/flake-registry.json
      '';

      nix.registry = {
        home-manager.flake = home-manager;
        nixpkgs.flake = nixpkgs;
        nur.flake = nur;
      };

      # Nixpkgs
      nixpkgs.overlays = [ emacs-overlay.overlay ];
    };

    # Modules common to a workstation
    workstation = { ... }: {
      imports = [
        self.nixosModules.common

        ./backup
        ./desktop

        ./devices/printers.nix
        ./devices/sdr.nix
        ./virtualisation/containers.nix
        ./virtualisation/libvirtd.nix
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
    };

    # Modules common to a server
    server = { ... }: {
      imports = [
        self.nixosModules.common

        ./backup

        ./web/letsencrypt.nix
        ./web/nginx.nix
        ./sshd.nix
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

        sops.defaultSopsFile = sopsFile;

        sops.secrets.host = lib.mkIf (builtins.pathExists sopsFile) sopsFile;
        sops.secrets.backup = lib.mkIf (builtins.hasAttr "backups" config) ../secrets/backup.yml;
      };

    backup = { ... } : {
      imports = [ ./backup ];
    };
  };
}
