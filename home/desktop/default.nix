{ self, pkgs, ... }:
let
  utterly-kanagawa = builtins.fetchGit {
    url = "https://github.com/candyclaws/Utterly-Kanagawa.git";
    rev = "9a24d61dbbc02d32c96667895be85c46313af0d8";
  };
in
{
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

    ./packages.nix
    ../lan-mouse
  ];

  programs.keychain.enableXsessionIntegration = true;

  programs.rbw = {
    enable = true;
    settings.pinentry = pkgs.pinentry-qt;
    settings.email = "m32@protonmail.com";
    settings.lock_timeout = 3600;
  };

  services.syncthing.enable = true;

  # QT/GTK Applications
  qt = {
    platformTheme = "kvantum";
    style = {
      name = "kvantum";
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.kanagawa-gtk-theme;
      name = "Kanagawa-BL-LB";
    };

    iconTheme = {
      package = pkgs.kanagawa-icon-theme;
      name = "Kanagawa";
    };

    font = {
      package = pkgs.nerd-fonts.hack;
      name = "Hack Nerd Font";
      size = 9;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
