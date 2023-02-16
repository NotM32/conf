{ ... }:
{
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      # Churchill Interlink
      "35c192ce9b255366"

      # M32 Srv Interlink
      "233ccaac27077fe3"
    ];
  };
}
