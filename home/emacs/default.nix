{ config, pkgs, ... }:
let
  emacs = with pkgs;
    (emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs:
      with epkgs; [
        treesit-grammars.with-all-grammars
        vterm
        notmuch
        mbsync
        offlineimap
      ]);

  doomReloadScript = with pkgs;
    writeScript "doom-reload" ''
      #!/bin/sh
      export PATH="${emacs}/bin:$PATH"

      ${config.home.homeDirectory}/.emacs.d/bin/doom -y sync -u
    '';

  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-basic dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of
      etoolbox metafont;
    #(setq org-latex-compiler "lualatex")
    #(setq org-preview-latex-default-process 'dvisvgm)
  });
in {
  home.packages = with pkgs; [
    black
    cargo-edit
    cargo-outdated
    clang-tools
    clippy
    dockerfile-language-server-nodejs
    dockfmt
    elixir-ls
    erlfmt
    fd
    hadolint
    helm-ls # helm (kubernetes package manager) language server
    html-tidy
    ispell
    libvterm
    nim
    nimlangserver
    nimlsp
    notmuch
    perlPackages.PerlLanguageServer
    racket-minimal
    ripgrep
    rubyPackages.prettier
    rubyPackages.pry
    rubyPackages.pry-doc
    rubyPackages.rubocop
    rubyPackages.ruby_parser
    rubyPackages.solargraph
    rust-analyzer
    rustfmt
    shellcheck
    shfmt
    solc
    stylelint
    svelte-language-server
    terraform-ls
    tex
    texlab
    tflint
    typescript-language-server
    yaml-language-server
    zig
  ];

  home = { sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin" ]; };

  programs.emacs = {
    enable = true;
    package = emacs;
  };

  # doom-emacs configuration
  # home.file.".doom.d" = {
  #   source = ./doom/.;
  #   recursive = true;
  #   onChange = "${doomReloadScript}";
  # };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = true;
  };
}
