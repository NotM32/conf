{ self, ... }: {
  perSystem = { pkgs, self', ... }: {
    packages = {
      docs = pkgs.callPackage ../docs/default.nix { inherit pkgs self; };
    };
  };
}
