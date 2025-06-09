{ pkgs, ... }: {
  services.displayManager.ly = {
    enable = false;

    settings = { animation = "doom"; };
  };
}
