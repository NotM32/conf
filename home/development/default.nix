{ self, pkgs, ... }: {
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    # * Tools
    direnv
    plandex
    plandex-server

    # * Languages
    gcc
    cargo
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.go = {
    enable = true;
    goPath = ".go";
  };
}
