{ pkgs, config, self, ... }: {

  imports = [
    self.homeModules.gpg
    self.homeModules.ssh
    self.homeModules.nushell

    ./packages.nix

    ./pam
  ];

  home = {
    stateVersion = "23.11";
    username = "m32";

    preferXdgDirectories = true;
  };

  home.packages = with pkgs; [ home-manager ];

  programs.home-manager.enable = true;
  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;

    userDirs = {
      desktop = "${config.home.homeDirectory}/docs/desktop";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates = "${config.home.homeDirectory}/docs/templates";
      videos = "${config.home.homeDirectory}/media/videos";
      extraConfig = {
        XDG_MISC_DIR = "${config.home.homeDirectory}/docs/misc";
        XDG_GIT_DIR = "${config.home.homeDirectory}/projects";
      };
    };
  };

}
