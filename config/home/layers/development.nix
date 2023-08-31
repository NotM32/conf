# * Profile for the various langs and things that are kept on hand in the user environment when  not using Nix flakes to complicate the development environment
{ pkgs, ... }:
{
  # golang
  programs.go = {
    enable = true;
    goPath = ".go";
  };

  home.packages = with pkgs; [
    # package managers
    yarn

    # Languages
    elixir
    nodejs
    python3
    gcc
  ];
}
