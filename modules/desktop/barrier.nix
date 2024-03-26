{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ barrier ];
  networking.firewall.allowedTCPPorts = [
    # Barrier
    24800
  ];
}
