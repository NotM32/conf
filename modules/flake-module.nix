{ self, inputs, ... }:
let
  inherit (inputs)
    nixpkgs
    disko
    lanzaboote
    sops-nix
    emacs-overlay
    stylix
    ;
in
{
  flake.nixosModules = {
    # Modules common to all configuration profiles
    common =
      { pkgs, ... }:
      {
        imports = [
          disko.nixosModules.disko
          lanzaboote.nixosModules.lanzaboote

          self.nixosModules.home-manager
          self.nixosModules.secrets

          ./nix.nix
          ./packages.nix
          ./system.nix

          ./networking
          ./security
          ./users
        ];

        # Nixpkgs
        nixpkgs.overlays = [ emacs-overlay.overlay ];
      };

    # Modules common to a workstation
    workstation =
      { ... }:
      {
        imports = [
          self.nixosModules.common
          stylix.nixosModules.stylix

          ./backup

          ./desktop
          ./desktop/boot.nix

          ./devices/android.nix
          ./devices/iphone.nix
          ./devices/printers.nix
          ./devices/sdr.nix
          ./security/firejail.nix
          ./containers/podman.nix

          ./services/ollama.nix
        ];

        # Home-manager users
        home-manager.users.m32 = nixpkgs.lib.mkDefault self.homeModules.desktop;

        # Stylix
        stylix.enable = true;

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

    # Module for handling secrets
    secrets =
      { ... }:
      {
        imports = [
          sops-nix.nixosModules.sops

          ./secrets.nix
        ];
      };

    backup = import ./backup;
  };
}
