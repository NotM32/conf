{ pkgs, ... }: {
  home.packages = [ pkgs.nufmt ];

  programs.nushell = {
    enable = true;

    plugins = (with pkgs.nushellPlugins; [
      formats
      gstat
      polars
      query
    ]);
  };

  # * Additional shell utils
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
