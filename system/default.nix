{ config, pkgs, lib, ... }:

{
  # Networking
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  # Users
  users.users.m32 = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "libvirtd" ];
  };

  # System Wide Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport = true;
  };

  # Security
  services.pcscd.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth  = true;
  };

  security.pam.yubico = {
    # Commands for onboarding with the chalresp key in the second slot:
    # ykman otp chalresp --touch --generate 2
    # ykpamcfg -2 -v
    enable = true;
    debug = true;
    mode = "challenge-response";
  };

  # Nix Options
  nix.package = pkgs.nixUnstable;

  nix.settings = {
    system-features = [ "recursive-nix" "kvm" "nixos-test" "big-parallel" ];
    experimental-features = [ "nix-command" "flakes" "recursive-nix" ];
  };

  nix.gc = {
    automatic = true;
    dates     = "08:00";
    options   = "--delete-older-than 14d";
  };

  nix.optimise = {
    automatic = true;
    dates     = [ "weekly" ];
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [
    # Barrier
    24800
  ];

  # Servers
  services.openssh.enable = true;

  services.avahi.enable       = true;
  services.avahi.openFirewall = true;

  services.printing.enable  = true;
  services.printing.drivers = with pkgs; [ cups-dymo ];

  # Containers
  virtualisation.podman.enable   = true;

  system.copySystemConfiguration = true;

  system.stateVersion = "22.11"; # Did you read the comment?

}
