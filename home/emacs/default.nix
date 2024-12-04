{ config, pkgs, doomemacs, ... }:
let
  emacs = with pkgs; (emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: with epkgs; [
    treesit-grammars.with-all-grammars
    vterm
    mu4e
  ]);

  doomReloadScript = with pkgs; writeScript "doom-reload"
    ''
    #!/bin/sh
    export PATH="${emacs}/bin:$PATH"

    ${config.home.homeDirectory}/.emacs.d/bin/doom -y sync -u
    '';
in {
 home.packages = with pkgs; [
    tflint # terraform linter
    terraform-ls # terraform language server
    helm-ls # helm (kubernetes package manager) language server
    texlab # texlab
    hadolint
    dockerfile-language-server-nodejs

    # shell
    shellcheck

    # perl
    perlPackages.PerlLanguageServer

    # rust
    clippy
    rustfmt
    cargo-edit
    cargo-outdated
    rust-analyzer

    # nim
    nim
    nimlangserver

    # zig
    zig

    # ruby
    rubyPackages.solargraph
    rubyPackages.pry
    rubyPackages.pry-doc
    rubyPackages.ruby_parser
    rubyPackages.rubocop
    rubyPackages.prettier

    # web
    html-tidy
    stylelint

    # elixir
    elixir-ls

    # Virtual Term support lib
    libvterm

    # faster file searches
    ripgrep
    fd

    # spell
    ispell
  ];

 home = {
   sessionPath = [ "${config.xdg.configHome}/doom/bin" ];
   sessionVariables = {
     DOOMDIR = "${config.xdg.configHome}/doom";
     DOOMLOCALDIR = "${config.xdg.stateHome}/doom";
   };
 };

  programs.emacs = {
    enable = true;
    package = emacs;
  };

  # spacemacs installation
  # home.file.".spacemacs".source = ./spacemacs.el;
  # home.file.".emacs.d" = {
  #   source = spacemacs;
  #   recursive = true;
  # };

   # doom-emacs configuration
   home.file.".doom.d/" = {
     source = ./doom/.;
     recursive = true;
     onChange = "${doomReloadScript}";
   };

   services.emacs = {
     enable = true;
     defaultEditor = true;
     startWithUserSession = true;
   };
}
