{ self ? { }, pkgs, stdenvNoCC, ... }:
stdenvNoCC.mkDerivation rec {
  pname = "docs";
  version = self.lastModifiedDate or "master";
  src = ./.;

  doCheck = true;

  buildInputs = with pkgs; [ coreutils mdbook ];
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    export PATH="${pkgs.lib.makeBinPath buildInputs}";
    # cargo install mdbook-nix-eval
    mdbook build ./
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./book/* $out
  '';
}
