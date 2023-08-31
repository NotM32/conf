/** Profile that includes all the graphical programs and things used on a client machine */
{ pkgs, ... }:
let
  font = "FiraCode Nerd Font";
in {
  # Git
  programs.git = {
    enable = true;
    userName = "m32";
    userEmail = "m32@m32.io";

    signing.signByDefault = true;
    signing.key = "0DF687B328D99A05";

    difftastic = {
      enable = true;
      color = "auto";
    };
  };

  # SSH
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    # forwardAgent   = true;
    # Host Level configuration
    matchBlocks = {
      # Personal
      "maple" = {
        hostname = "git.m32.me";
        forwardAgent = true;
      };
      "phoenix" = {
        hostname = "10.127.0.66";
        forwardAgent = true;
      };
      "momentum" = {
        hostname = "10.127.0.2";
        forwardAgent = true;
      };
      "router1" = {
        hostname = "10.127.0.1";
        forwardAgent = true;
      };

      # Churchill
      "access1.net.churchill" = {
        hostname = "68.64.164.174";
        forwardAgent = true;
      };
      "switch0.net.churchill" = {
        hostname = "68.64.164.170";
        forwardAgent = true;
      };
      "switch1.net.churchill" = {
        hostname = "68.64.164.171";
        forwardAgent = true;
      };

      # Colorado Colo Network
      "jumpbox.colo" = {
        hostname = "68.64.160.2";
        forwardAgent = true;
      };
      "ns1.colo" = {
        hostname = "ns1.corporatecolo.com";
        forwardAgent = true;
        extraOptions = { hostKeyAlgorithms = "ssh-rsa"; };
      };

    };
  };

  # GPG and SSH agent lifecycle
  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableXsessionIntegration = true;
    agents = [ "ssh" "gpg" ];
    keys = [
      # General
      "id_ed25519"
      "id_rsa"
      "id_rsa_secondary"

      # Clients
      "id_ed25519_churchill"
    ];
  };

  # Terminal Emulator
  programs.alacritty = {
    enable = true;
    settings = {
      env = { TERM = "alacritty"; };
      window = {
        title = "terminal";
        dynamic_title = true;
      };
      scrolling = { history = 10000; };
      font = {
        normal = { family = font; };
        bold = { family = font; };
        size = 10;
      };
      colors = {
        primary = {
          background = "0x1f1f1f";
          foreground = "0xededed";
        };
        normal = {
          black = "0x4a3637";
          red = "0xd14951";
          green = "0x7b8748";
          yellow = "0xaf865a";
          blue = "0x535c5c";
          magenta = "0x775759";
          cyan = "0x6d715e";
          white = "0xc0b18b";
        };
        bright = {
          black = "0x402e2e";
          red = "0x98353b";
          green = "0x647035";
          yellow = "0x8f673e";
          blue = "0x324b4b";
          magenta = "0x614445";
          cyan = "0x585c49";
          white = "0x978965";
        };
      };
      shell = { program = "fish"; };
      key_bindings = [
        {
          key = "Key0";
          mods = "Control";
          action = "ResetFontSize";
        }
        {
          key = "Plus";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
      ];
    };
  };

  # Passwords and secrets source
  programs.rbw = {
    enable = true;
    settings.pinentry = "qt";
    settings.email = "m32@protonmail.com";
    settings.lock_timeout = 3600;
  };

  # Mobility
  services.syncthing.enable = true;
  services.kdeconnect.enable = true;

  # pdf / ebook reader
  programs.zathura.enable = true;

  # Extra packages
  home.packages = with pkgs; [
    # Internet
    signal-desktop
    hexchat
    element-desktop
    protonvpn-gui
    filezilla

    # Games
    lutris
    steam

    # Environment
    alacritty # fast terminal emulator
    barrier # the software kvm
    plasma5Packages.bismuth # Tiling functionality in KDE

    # Media
    spotify
    psst
    vlc
    obs-studio
    gimp
    inkscape
    krita

    # Office
    obsidian
    onlyoffice-bin
    libreoffice
    unoconv

    # Infrastructure tools
    kubectl
    kubernetes-helm
    terraform
    ansible
    pulumi
    ansible
    buildah

    # Utilities
    ddcutil # cli tool for controlling digital monitors without using their OSDs
    ddcui # GUI for ddcutil
    git-latexdiff # More helpful diffs for latex files in git
  ];
}
