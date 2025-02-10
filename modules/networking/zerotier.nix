{ lib, config, ... }:
with lib;
let cfg = config.conf.network.zerotier;
in {
  options = {
    conf.network.zerotier = {
      enable = mkEnableOption "conf zerotier module";
      networks = mkOption {
        description = "Configuration values for networks";
        default = { };
        type = types.attrsOf (types.submodule {
          options = {
            autoAssignAddr =
              mkEnableOption "host IPv4/6 address auto assignment";

            memberId = mkOption {
              type = types.str;
              description =
                "Member id of the host NOTE: this does not set the member id";
              default = "";
            };

            ipAssignments = mkOption {
              type = types.listOf types.str;
              description = "List of static addresses to assign to the host";
            };
          };
        });
      };

    };
  };

  config = {
    services.zerotierone = {
      enable = cfg.enable;
      joinNetworks = attrNames cfg.networks;
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "zerotierone" ];
  };
}
