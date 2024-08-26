{ ... }: {
  nix.registry = {
    "m32conf" = {
      from = {
        id = "m32conf";
        type = "indirect";
      };

      to = {
        type = "git";
        url = "ssh://git@github.com/notm32.git";
      };
    };
  };
}
