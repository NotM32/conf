{ lan-mouse, ... }: {
  imports = [ lan-mouse.homeManagerModules.default ];

  programs.lan-mouse = {
    enable = true;
    systemd = true;
    settings = builtins.fromTOML (builtins.readFile ./lan-mouse.toml);
  };
}
