{ pkgs, ... }:
{
  imports = [ ./sddm.nix ];

  environment.systemPackages = with pkgs; [
    qt6.qtwayland
    qt5.qtwayland
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
