{ flake-utils, nixpkgs, self, ... }:
flake-utils.lib.eachDefaultSystem (system:
  let pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages = {
      docs = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "m32meconf-docs";
        version = self.lastModifiedDate;
        src = self;

        doCheck = true;

        buildInputs = with pkgs; [ coreutils mdbook ];
        phases = [ "unpackPhase" "buildPhase" "installPhase" ];

        buildPhase = ''
          export PATH="${pkgs.lib.makeBinPath buildInputs}";
          cargo install mdbook-nix-eval
          mdbook build ./docs/
        '';

        installPhase = ''
          mkdir -p $out
          cp -r ./docs/book/* $out
        '';
      };
    };

    devShells = {
      default = pkgs.mkShell {
      inputsFrom = builtins.attrValues self.packages.${system};
      # packages = with pkgs; [ ];
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
  })
