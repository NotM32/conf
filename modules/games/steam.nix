{ ... }: {
  programs.steam.enable = true;

  allowUnfreePackages = [ "steam" "steam-original" "steam-runtime" "steam-run" ];
}
