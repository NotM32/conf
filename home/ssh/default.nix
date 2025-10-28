{ ... }: {
  programs.ssh = {
    enable = true;

    # Host Level configuration
    # TODO: Pull this in from ZeroTier somehow
    matchBlocks = {
      # All Hosts
      "*" = {
        forwardAgent = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;

        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%n:%p:";
        controlPersist = "10m";
      };

      # Personal
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
      "nova" = {
        hostname = "10.127.0.3";
        forwardAgent = true;
      };
    };
  };

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
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
