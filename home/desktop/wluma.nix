{ ... }: {
  services.wluma = {
    enable = false;

    systemd.enable = true;
    systemd.target = "wayland-session@Hyprland.target";

    settings = builtins.fromTOML (builtins.readFile ./wluma.toml);
  };
}
