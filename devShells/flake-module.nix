{ self, inputs, ... }:
{
  perSystem = { inputs', self', pkgs, system, ... }: {
    devShells.default = pkgs.mkShell {
      buildInputs = [
        self.packages.${system}.configuration-docs

        pkgs.ipmitool
        pkgs.python3.pkgs.invoke
        inputs.nixos-anywhere.packages.${system}.nixos-anywhere-pxe
        pkgs.mypy
        pkgs.pixiecore
        pkgs.dnsmasq
        pkgs.python3.pkgs.netaddr
        pkgs.openssh
        pkgs.gitMinimal
        pkgs.rsync
        pkgs.coreutils
        pkgs.curl
        pkgs.gnugrep
        pkgs.findutils
        pkgs.gnused
        pkgs.sops
        pkgs.jq
        pkgs.opentofu
      ] ++ pkgs.lib.optional (pkgs.stdenv.isLinux) pkgs.mkpasswd;

      shellHook = ''
        alias devdocs='mdbook serve --port 3025 --open ./docs/'
        alias mkdocs='nix build .#docs'
        alias nsp='nix search nixpkgs'
        alias dh='echo -e "$DEVSHELL_HELP"'

        DEVSHELL_HELP="
        Devshell Command Glossary
        [docs] devdocs       | Start the mdbook watch server
               mkdocs        | Build the docs

        [util] nixos-option  | Search for nixos options
               nsp {package} | Search nixpkgs
               dh            | Show this again
      "

      echo -e "$DEVSHELL_HELP"
      '';
    };
  };
}
