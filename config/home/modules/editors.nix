/** Profile for emacs configurations */
{ inputs, pkgs, ... }:
{

  # Emacs
  programs.emacs.enable = true;
  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = true;
  };
  home.file.".spacemacs".source = ./emacs/spacemacs.el;
  home.file.".emacs.d" = {
    source = inputs.spacemacs;
    recursive = true;
  };

  services.mbsync = {
    enable = true;
    preExec = "mkdir -p ~/mail/protonmail/";
    configFile = ./mail/mbsyncrc;
  };

  # The other one
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      apollographql.vscode-apollo
      b4dm4n.vscode-nixpkgs-fmt
      bbenoist.nix
      chenglou92.rescript-vscode
      bierner.markdown-mermaid
      bierner.markdown-checkbox
      dart-code.flutter
      elixir-lsp.vscode-elixir-ls
      elmtooling.elm-ls-vscode
      golang.go
      hashicorp.terraform
      graphql.vscode-graphql
      influxdata.flux
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-azuretools.vscode-docker
      phoenixframework.phoenix
      prisma.prisma
      scala-lang.scala
      svelte.svelte-vscode
      rust-lang.rust-analyzer
    ];
  };

  home.packages = with pkgs; [
    # For emacs
    libvterm

    # Language Servers
    tflint # terraform linter
    terraform-ls # terraform language server
    helm-ls # helm (kubernetes package manager) language server
    gopls # gopls
    texlab # texlab
    rnix-lsp # the standard nix-lsp
    nil # nil is a better nix lsp

    # Code Format
    nixfmt # formatter for nix

    # Other editor tools
    direnv
    nurl # nix-prefetch but more useful
    nixos-option # command line search of nixos option declarations

    # Development tools that aren't emacs
    insomnia
  ];
}
