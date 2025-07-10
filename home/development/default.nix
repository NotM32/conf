{ self, pkgs, ... }: {
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    opencode
    # * Tools
    direnv

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
