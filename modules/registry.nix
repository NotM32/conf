{ ... }: {
  nix.registry = {
    "m32conf" = {
      from = {
        id = "m32conf";
        type = "indirect";
      };

      to = {
        type = "git";
        url = "ssh://gitea@git.m32.me/conf/m32.me.git";
      };
    };
  };
}
