{ self, inputs, ... }:
{
  perSystem = { inputs', self', pkgs, system, ... }: {
    devShells.default = pkgs.mkShell {
      buildInputs = [
        self.packages.${system}.docs

        pkgs.ipmitool
        inputs.nixos-anywhere.packages.${system}.nixos-anywhere-pxe
        pkgs.pixiecore
        pkgs.dnsmasq
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
        pkgs.pam_u2f
        pkgs.otpw
        pkgs.oath-toolkit
        pkgs.pamtester
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
