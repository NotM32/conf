{ ... }:
{
  networking.firewall = {
    allowedUDPPorts = [
      4242 # lan mouse
    ];
  };
}
