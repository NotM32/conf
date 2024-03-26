{ pkgs, ... }:
{
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    podman-tui
  ];
}
