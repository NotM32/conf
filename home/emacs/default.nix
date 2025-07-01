{
  config,
  pkgs,
  self,
  ...
}:
let
  package =
    with pkgs;
    (emacsPackagesFor emacs-git-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        (treesit-grammars.with-all-grammars)
        (treesit-grammars.with-grammars (grammars: [
          self.inputs.nix-qml-support.packages.${pkgs.stdenv.system}.tree-sitter-qmljs
        ]))
        vterm
        notmuch
        mbsync
        offlineimap
      ]
    );

  doomReloadScript =
    with pkgs;
    writeScript "doom-reload" ''
      #!/bin/sh
      export PATH="${emacs}/bin:$PATH"

      ${config.home.homeDirectory}/.emacs.d/bin/doom -y sync -u
    '';

  tex = (
    pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-basic
        dvisvgm
        dvipng # for preview and export as html
        wrapfig
        amsmath
        ulem
        hyperref
        capt-of
        etoolbox
        metafont
        ;
    }
  );
in
{
  home.packages = with pkgs; [
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
      ]
    ))
    black
    cabal-install
    cargo-edit
    cargo-outdated
    clang-tools
    clippy
    dockerfile-language-server-nodejs
    dockfmt
    elixir-ls
    erlfmt
    fd
    ghc
    gomodifytags
    gopls
    gore
    hadolint
    haskell-language-server
    haskellPackages.hoogle
    helm-ls # helm (kubernetes package manager) language server
    html-tidy
    ispell
    languagetool
    libvterm
    libxml2
    nil
    nim
    nimlangserver
    nimlsp
    nodejs
    notmuch
    perlPackages.PerlLanguageServer
    python3Packages.editorconfig
    racket
    ripgrep
    ruby
    rubyPackages.prettier
    rubyPackages.pry
    rubyPackages.pry-doc
    rubyPackages.rubocop
    rubyPackages.ruby_parser
    rubyPackages.solargraph
    rust-analyzer
    rustc
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
    zls
  ];

  home = {
    sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin" ];
  };

  programs.emacs = {
    inherit package;
    enable = true;
  };

  # doom-emacs configuration
  # home.file.".doom.d" = {
  #   source = ./doom/.;
  #   recursive = true;
  #   onChange = "${doomReloadScript}";
  # };

  services.emacs = {
    inherit package;
    enable = true;
    defaultEditor = true;
    startWithUserSession = true;
  };
}
