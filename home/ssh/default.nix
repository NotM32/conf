{ config, ... }: {

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";

    # Host Level configuration
    matchBlocks = {
      # Personal
      "maple" = {
        hostname = "10.127.1.1";
        forwardAgent = true;
      };
      "phoenix" = {
        hostname = "10.127.0.66";
        forwardAgent = true;
      };
      "momentum" = {
        hostname = "10.127.0.2";
        forwardAgent = true;
      };
      "router1.m32.me" = {
        hostname = "10.127.0.1";
        forwardAgent = true;
      };
    };
  };

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = config.programs.fish.enable;
    agents = [ "ssh" "gpg" ];
    keys = [
      # General
      "id_ed25519"
      "id_rsa"
      "id_rsa_secondary"

      # Clients
      "id_ed25519_churchill"
    ];
  };
}