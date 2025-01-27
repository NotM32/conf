{ pkgs, config, ... }: {

  imports = [ ./gpg ./ssh ./pam ./shell/nu.nix ];

  home.packages = with pkgs; [
    # Nix Utilities
    nurl
    nixos-option
    nil
    nixfmt

    # Utilities
    freeipmi
    htop
    minicom
    mosh
    aria2
  ];

  home = {
    stateVersion = "23.11";
    username = "m32";

    preferXdgDirectories = true;
  };

  programs.home-manager.enable = true;

  # Home Structure
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

  programs.nushell.enable = true;

  programs.fish = { enable = true; };

  programs.broot = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableNushellIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "m32";
    userEmail = "m32@m32.io";

    signing.signByDefault = true;
    signing.key = "EF5FDF7F8EAC7878";

    difftastic = {
      enable = true;
      color = "auto";
    };

    # Additional configuration not defined in modules
    includes = [{ contents = { safe.directory = [ "/etc/nixos" ]; }; }];
  };

}
