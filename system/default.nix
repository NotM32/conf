{ config, pkgs, lib, ... }:

{
  imports = [ ];

  # Networking
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      # Churchill Interlink
      "35c192ce9b255366"

      # M32 Srv Interlink
      "233ccaac27077fe3"
    ];
  };

  time.timeZone = "America/Los_Angeles";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # X11 Video Drives
  services.xserver.videoDrivers = [ "displaylink" "modesetting" "nvidia" ];
  hardware.opengl.enable        = true;

  # DisplayLink provider output sink enablement
  services.xserver.displayManager.sessionCommands = ''
      ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';

  # Remap X-11 Keys (remaps alt and win for the "for mac" keychron clone keyboard that was $50 cheaper than a normal layout)
  services.xserver.xkbOptions = "altwin:swap_alt_win";

  # SDDM Display Manager (kde)
  services.xserver.displayManager.sddm.enable      = true;
  services.xserver.displayManager.sddm.enableHidpi = true;
  services.xserver.displayManager.setupCommands    = ''
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --mode 1920x1080 --rate 239.96 --orientation left --right-of DVI-I-1-1
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --output DVI-I-1-1 --mode 4096x2160 --rate 50
  '';

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.desktopManager.plasma5.enable   = true;

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
  };


  # Users
  users.users.m32 = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "libvirtd" ];
  };

  # Unfree Software
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "obsidian"
    "spotify"
    "zerotierone"
    "nvidia-x11"
    "nvidia-settings"
    "displaylink"
  ];

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
    sudo.u2fAuth  = false;
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

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable          = true;

  system.copySystemConfiguration = true;

  system.stateVersion = "22.11"; # Did you read the comment?

}
