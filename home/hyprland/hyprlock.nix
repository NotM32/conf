{ ... }: {

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];
    };
  };
}
