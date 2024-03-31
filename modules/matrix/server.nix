{ config, ... }:
let
  fqdn = "${config.networking.domain}";
  serverConfig = {
    "m.server" = "${config.services.matrix-synapse.settings.server_name}:443";
  };

in {
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "m32.io";
      listeners = {

      };
    };
  };
}
