{ pkgs, ... }: {
  home.packages = [ pkgs.nufmt ];

  programs.nushell = {
    enable = true;

    # Plugins
    plugins = (with pkgs.nushellPlugins; [ formats gstat polars query hcl ]);

    # Config
    extraConfig = builtins.readFile ./config.nu;

    settings = { buffer_editor = "emacsclient"; };

    # Environment
    environmentVariables = { EDITOR = "emacsclient"; };
  };

  # Prompt
  programs.starship = { enable = true; };

  #  Shell Integrations
  home.shell.enableNushellIntegration = true;
  programs.broot = {
    enable = true;
    enableNushellIntegration = false;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.direnv.enableNushellIntegration = true;
  programs.keychain.enableNushellIntegration = true;
}
