{ self, inputs, ... }:
let
  inherit (inputs) home-manager;
in {
  flake.nixosModules = {
    home-manager = {
      imports = [
        home-manager.nixosModules.home-manager
        ({
          extraSpecialArgs = { inherit self; } // inputs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        })
      ];
    };
  };
}
