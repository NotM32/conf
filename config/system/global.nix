{ pkgs, inputs, lib, config, ... }:

{
  time.timeZone = "America/Los_Angeles";

  # System Wide Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    unzip
    lm_sensors
    wireguard-tools
    nixos-option
    cachix
  ];

  # Personal stuff is under m32.me
  networking.domain = "m32.me";

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
    debug  = false;
    mode   = "challenge-response";
  };

  # Nix Options
  nix.package = pkgs.nixUnstable;

  nix.registry = {
    "m32conf" = {
      from = {
        id = "m32conf";
        type = "indirect";
      };

      to = {
        type = "git";
        url = "ssh://gitea@git.m32.me/conf/m32.me.git";
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings = {
    system-features = [ "recursive-nix" "kvm" "nixos-test" "big-parallel" ];
    experimental-features = [ "nix-command" "flakes" "recursive-nix" ];
    trusted-users = [ "root" "m32" ];
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

  # Automatic Upgrades / Configuration sync
  system.autoUpgrade = {
    enable = true;
    flake = "m32conf";
    flags = [
      # Something keeps flipping out, haven't traced it yet
      "--impure"
    ];
  };

  # Containers
  virtualisation.podman.enable   = true;

  # Store commit data in generation label
  system.nixos.label =
    lib.mkIf (inputs.self ? rev)
    "${inputs.self.shortRev}-${lib.concatStringsSep "-" ((lib.sort (x: y: x < y) config.system.nixos.tags))}";

  # Also store commit revision where it can be accessed with `nixos-version`
  system.configurationRevision = inputs.self.rev or "dirty";

  # And finally, link the latest version of the subscribed flake to /etc/nixos, so it can be built from.
  # this is a pure flake option similar to that of system.copySystemConfiguration, but for another purpose
  environment.etc = {
    "nixos" = {
      source = "${inputs.self.sourceInfo.outPath}/**";
    };
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
