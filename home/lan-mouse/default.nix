{ lan-mouse, lib, ... }:
{
  imports = [ lan-mouse.homeManagerModules.default ];

  programs.lan-mouse = {
    enable = true;
    systemd = true;
    settings = builtins.fromTOML (builtins.readFile ./lan-mouse.toml);
  };

  # Upstream module does not recognize UWSM
  systemd.user.services.lan-mouse.Install.WantedBy = lib.mkForce [
    "wayland-session@Hyprland.target"
  ];
}
