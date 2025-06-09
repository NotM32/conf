{ pkgs, ... }:
{
  imports = [ ./gdm.nix ];

  environment.systemPackages = with pkgs; [
    qt6.qtwayland
    qt5.qtwayland
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
}
