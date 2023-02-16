{
  description = "m32.srv and system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";

  };


  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {

    hosts =
      let
        util = import ./util inputs;

        # Users / Home Conf
        users = {
          m32 = import ./config/home.nix;
        };

      in
        # Hosts
        {
          phoenix = util.makeSystemConfiguration
            { hardwareConfig = ./machines/phoenix.nix;
              systemConfig = ./system;
              hmUsers = users;
            };
        };

    nixosConfigurations = {

      # phoenix desktop
      phoenix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./machines/phoenix.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.m32 = import ./config/home.nix;
          }
        ];

        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
