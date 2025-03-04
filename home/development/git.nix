{ pkgs, ... }: {
  # * Config
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

  # * Packages
  home.packages = with pkgs; [
    git-latexdiff # More helpful diffs for latex files in git
  ];
}
