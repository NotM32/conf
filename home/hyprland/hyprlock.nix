{ ... }:
let
  font_family = "Hack Nerd Font";
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 12;
      }];

      input-field = {
        size = "20%, 4%";
        outline_thickness = 2;
        inner_color = "rgba(18181bee)";

        outer_color = "rgba(ff6600ee) rgba(81381aee) 45deg";
        check_color = "rgba(ff6600ee) rgba(81381aee) 120deg";
        capslock_color = "rgb(f2c866)";
        bothlock_color = "rgb(f2c866)";
        fail_color = "rgba(cd5c60ee) rgba(e36d5bee) 40deg";

        font_color = "rgb(e4e4e8)";
        inherit font_family;
        fade_on_empty = false;
        rounding = 0;

        hide_input = false;
        hide_input_base_color = "rgba(cd5c60)";

        position = "0, -20";
        halign = "center";
        valign = "center";

        placeholder_text = "";
        fail_text = "⛔ <b>($ATTEMPTS)</b>";
      };

      label = {
        text = "$TIME";
        color = "rgb(e4e4e8)";
        font_size = 25;
        inherit font_family;

        position = "0, 80";
        halign = "center";
        valign = "center";
      };
    };
  };
}
