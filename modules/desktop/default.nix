{ pkgs, ... }: {
  imports = [ ./audio.nix ./fonts.nix ./keyboard.nix ];

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Some Electron apps show black screens in wayland unless this is set
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    # Utils
    glxinfo
    clinfo
    wayland-utils
    vulkan-tools
  ];

}
