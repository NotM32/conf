/* Base profile inherited by all other configurations of my user. */
{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    stateVersion = "23.11";
  };

  # Home directory structure -- I like it this way
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
    };

    userDirs.extraConfig = {
      XDG_MISC_DIR = "${config.home.homeDirectory}/docs/misc";
      XDG_GIT_DIR = "${config.home.homeDirectory}/projects";
    };
  };

  # Shell
  programs.fish = { enable = true; };

  # GPG
  programs.gpg = {
    enable = true;
    publicKeys = [{ source = ./gpg/pubkey.asc; }];
  };


  home.packages = with pkgs; [

    # # Utilities
    htop
    nmap
    minicom
    mosh
    dmidecode
    ipmitool
  ];
}
