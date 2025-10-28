{ pkgs, config, ... }: {
  imports = [ ./git.nix ];

  home.packages = with pkgs; [
    opencode
    direnv

    gcc
    cargo
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.go = {
    enable = true;
    env.GOPATH = "${config.home.homeDirectory}/.go";
  };

  programs.kubeswitch.enable = true;

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };

  programs.awscli.enable = true;
}
