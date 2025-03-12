{ lib, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      env = { TERM = "alacritty"; };
      window = {
        title = "terminal";
        dynamic_title = true;
      };
      scrolling = { history = 10000; };
      font = {
        normal = { family = "Hack Nerd Font"; };
        bold = { family = "Hack Nerd Font"; };
        size = 9;
      };
      colors = (lib.importTOML ./kaolin_dark.toml).colors;
      terminal.shell = { program = "nu"; };
      keyboard.bindings = [
        {
          key = "Key0";
          mods = "Control";
          action = "ResetFontSize";
        }
        {
          key = "Plus";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
      ];
    };
  };
}
