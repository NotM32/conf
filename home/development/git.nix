{ pkgs, ... }: {
  # * Config
  programs.git = {
    enable = true;

    settings.user.name = "m32";
    settings.user.email = "m32@m32.io";

    signing.signByDefault = true;
    signing.key = "EF5FDF7F8EAC7878";

    # Additional configuration not defined in modules
    includes = [
      { contents = { safe.directory = [ "/etc/nixos" ]; }; }
      {
        contents = {
          help.autocorrect = "prompt";
          tag.sort = "version:refname";
          column.ui = "auto";
          rerere.enabled = true;
          rerere.autoupdate = true;
          rebase.autoSquash = true;
          rebase.autoStash = true;
          rebase.updateRefs = true;
        };
      }
    ];

  };
  programs.difftastic = {
    enable = true;
    git.enable = true;
    options.color = "auto";
  };

  # * Packages
  home.packages = with pkgs;
    [
      git-latexdiff # More helpful diffs for latex files in git
    ];
}
