{ pkgs, ... }:
{
  programs.wofi = {
    enable = true;

    settings = {
      gtk_dark = true;
    };
  };

  home.packages = with pkgs; [ wofi-power-menu ];
}
