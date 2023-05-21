{ pkgs, inputs, lib, config, ... }:

{
  time.timeZone = "America/Los_Angeles";

  # Users
  users.users.m32 = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "libvirtd" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJ+vXoQNGzmaE6POgYEiPi67rK9vCq8X2uPD0erkdec3DK4qIzCb33PMHLOe0bzRyxrAsimAGD3RUVeDjdeS7TzY1CvEU5DGimU36M2UV6o5LnxRCQYZP+snModYL68zm/csVVfEkL2+kHXpNCBdG3scU3T3K4krRU8YCtDPrRxDjDW3mh6j3qXc2VJqo9LfKoGW9bxWSkTPLKevQgy+eTIdyrgomxf+0zonIXPh0V17NFHKMVsQC3z+wvd73yW3jM61JFfjGpQexs7d6n7/6akrRTyhWn4kTwRtkdi9xIs9OolBF8I3Ed2BFZtwxz1aJ69CYLwAVt6LpfmQcJtNDHOiiQBsItBJ5cV/1PAtiaxO1WuBW/MZwOV+2glo/AKvmTF7WTfZy6u4BNcYf7dv1XV7Yy4EmqEqGZDS4xKu4vkFh4E0u1ZnJVDWP9fYFOQu9BeOW9qvv+btzrKGrcF5LGnxOk/QIMRExAZqeJnoZOUCa0v8iHdMrqbdcG2xcGW28= m32@phoenix"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD5/30rkcFI8JSbyl0KhsPSaR28dtiyfvrgddZ5A/po9rOmNFwjYy7OM5HBxNW9S2qUZ8XpUNZy6pagDvw0IFtIXPCvi2I3lyxl2CDveWPkn/HMEXHzhAm6JAu3FGum9XAem64+8PXdDpUVWwuU2jDHnm0YzkF6YQqS0Wq6WSb+UyPygNKxA0YOZChk11uOborTQv6dImLBg60ZNBQn95NqsiU1v6RXPyObjZOOiMqauxmk4RnGRORGtWRzs1EpnLUE61Jj/6p5/eezhYCL25Kfdzmv93pRCsYLqIJcaZiNP5PPYK/0vkKy9X/pF08WMfgytW4zfnPX8CoERHK1VAXFE9WfZ14H1hycZ3zZ4PoWvbSRJsrHjmb00ezDf1w1gBJJQoe7zJe73Xj8wR84B0iftD3qMsJjhlAyat/na/GGdvKj9zy8mbGh+Dys6vnq/xQesBscQB/3thn8SzzJK5vSrySudY6DgzPjk1Rjdu4RNb1J+Si1PeYbfxEJoQBPJHk= m32@phoenix"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1jQvI/he9ARVieh50WosWrO3C3bk0FSzLOokbrWVSUQoh3PLxeEgda14EtIyiOMca2NngX6JAnHOa0Ai1DpmsMC+JQoAOU0HLO2zUWSpBAoycYc4ao3asnuCwBFeCycvk6XlTpBxpfwPKjuWpMYND4YCHiP+twyQA1MnEQ2qL2Lqrl4x8PcOiy+4NO8ipT7BucuhTk9pNjwJ81dDcg5u47l72BSthduvQ3N2yBL3YV5USWHQJAJdIufavE1mI0wyZNLnovbs1sym9MkBm/miZeVaO1OEWr1ZlxfI5sau1RetcjsS5fxAZyxZWJYTvCTyzF2+1d44f/OzeHTk7Q/k+Jk40PJ1hUpiFphSmXWLM0l2qUGSloAnr6ctQ1bPAWN3Jpyo9GGCSEc8JPBycZJg/Ic4xYaqsbik6L7JrGsqKyUqu51YPOzaSPS2EvDM6MZ4FrFwtBfNRqHAd52np/cH4OhKoDEEtXpb81h9f+1R74IFWMPR0j+YPePkdX5sAmZc= m32@amnesia"
	  ];
  };

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

  # Containers
  virtualisation.podman.enable   = true;

  # Incompatible with pure mode flakes
  system.copySystemConfiguration = false;

  # Store commit data in generation label
  system.nixos.label =
    lib.mkIf (inputs.self ? rev)
    "${inputs.self.shortRev}-${lib.concatStringsSep "-" ((lib.sort (x: y: x < y) config.system.nixos.tags))}";

  # Also store commit revision where it can be accessed with `nixos-version`
  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.self.rev;

  system.stateVersion = "22.11"; # Did you read the comment?

}
