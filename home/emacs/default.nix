{ pkgs, spacemacs, ... }:
{
  imports = [ ../mail ];

  home.packages = with pkgs; [
    # ## Language Servers
    tflint # terraform linter
    terraform-ls # terraform language server
    helm-ls # helm (kubernetes package manager) language server
    gopls # gopls
    texlab # texlab
    hadolint
    dockerfile-language-server-nodejs
    perlPackages.PerlLanguageServer
    clippy
    rustfmt
    cargo-edit
    cargo-outdated
    rubyPackages.solargraph
    rubyPackages.pry
    rubyPackages.pry-doc
    rubyPackages.ruby_parser
    rubyPackages.rubocop
    rubyPackages.prettier

    # Virtual Term support lib
    libvterm
  ];

  programs.emacs = {
    enable = true;
    # from emacs-overlay, resolved screen flicker and scaling issues
    package = pkgs.emacs-pgtk;
  };

  # spacemacs installation
  home.file.".spacemacs".source = ./spacemacs.el;
  home.file.".emacs.d" = {
    source = spacemacs;
    recursive = true;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = true;
  };

  mail.mbSync.enable = true;

}
