{ ... }:
{
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "m32.io";
      listeners = {

      };
    };
  };
}
