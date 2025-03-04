{ self, pkgs, ... }: {
  imports = [
    self.homeModules.emacs

    ./git.nix
  ];

  home.packages = with pkgs; [
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
