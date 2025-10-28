{ self, pkgs, lib, ... }:
let
  utterly-kanagawa = pkgs.fetchFromGitHub {
    owner = "james-mkn";
    repo = "Utterly-Kanagawa";
    rev = "main";
    hash = "sha256-t8zR6NYvV0TCd1+cbThWW1Zh58HdriXVG8ukM01pAFw=";
  };
in {
  imports = [
    self.homeModules.default
    self.homeModules.development

    self.homeModules.alacritty
    self.homeModules.emacs
    self.homeModules.firefox
    self.homeModules.hyprland
    self.homeModules.mail
    self.homeModules.nushell
    self.homeModules.quickshell
    self.homeModules.ssh
    self.homeModules.stylix

    ./packages.nix
    ../lan-mouse

    ./wluma.nix
  ];

  home.packages = with pkgs; [ libsForQt5.qt5ct qt6ct ];

  programs.keychain.enableXsessionIntegration = true;

  programs.rbw = {
    enable = true;
    settings.pinentry = pkgs.pinentry-qt;
    settings.email = "m32@protonmail.com";
    settings.lock_timeout = 3600;
  };

  services.syncthing.enable = true;

  services.easyeffects.enable = true;

  # QT/GTK Applications
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "kvantum";
      package = with pkgs; [
        libsForQt5.qtstyleplugin-kvantum # Qt5 plugin
        qt6Packages.qtstyleplugin-kvantum # Qt6 plugin
      ];
    };
  };

  # QT Theme Settings via Kvantum
  xdg.configFile = {
    "Kvantum/Utterly-Kanagawa" = {
      source = utterly-kanagawa;
      recursive = true;
    };

    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Utterly-Kanagawa
    '';
  };

  gtk.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = lib.mkForce "prefer-dark";
    };
  };
}
