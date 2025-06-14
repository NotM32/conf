{ self, pkgs, ... }: {
  imports = [
    self.homeModules.default
    self.homeModules.development

    self.homeModules.alacritty
    self.homeModules.emacs
    self.homeModules.firefox
    self.homeModules.hyprland
    self.homeModules.mail
    self.homeModules.nushell
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

  services.poweralertd = {
    enable = true;
  };

  services.syncthing.enable = true;
}
