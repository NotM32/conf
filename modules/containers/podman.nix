{ pkgs, ... }: {
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = with pkgs; [ docker-compose podman-tui ];
}
