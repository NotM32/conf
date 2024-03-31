{ self, ... }:
{
  perSystem = { pkgs, self', ... }: {
    packages = {
      configuration-docs = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "configuration-docs";
        version = self.lastModifiedDate;
        src = self;

        doCheck = true;

        buildInputs = with pkgs; [ coreutils mdbook ];
        phases = [ "unpackPhase" "buildPhase" "installPhase" ];

        buildPhase = ''
          export PATH="${pkgs.lib.makeBinPath buildInputs}";
          # cargo install mdbook-nix-eval
          mdbook build ./docs/
        '';

        installPhase = ''
          mkdir -p $out
          cp -r ./docs/book/* $out
        '';
      };
    };
  };
}
