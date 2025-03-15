{ self ? { }, pkgs, stdenvNoCC, ... }:
stdenvNoCC.mkDerivation rec {
  pname = "configuration-docs";
  version = self.lastModifiedDate or "master";
  src = self or "./.";

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
}
