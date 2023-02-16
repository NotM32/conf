{
  description = "m32.srv and system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";

    deploy.url = "github:serokell/deploy-rs";

  };


  outputs = inputs@{ self, nixpkgs, home-manager, deploy, ... }:
    # Variables in the let scope are used for composing the actual user configurations,
    # host configuration, hardware configurations, deploy nodes etc.

    # They are meant to be the inputs provided to the utility functions that create the
    # actual flake outputs.

    # While the use of multiple let statements isn't as syntactically satisfying as the use
    # of an attr set with a complex main function, keeping things scoped like this makes
    # things a whole lot clearer in terms of what is actually happening.
    let
      # - IMPORTS -
      util = import ./util { inherit inputs; };

      # - BEGIN CONFIG -

      # Users / Home Conf
      users.m32 = import ./config/home.nix;

    in
    let
      inherit users util;

      # Host Composition
      hosts =
        { # ** Hosts
          # Desktop
          phoenix =
            { hardwareConfig = [ ./machines/phoenix ];
              systemConfig = [ ./system ];
              hmUsers = users;
            };

          # T430 laptop
          momentum =
            { hardwareConfig = [ ./machines/phoenix ];
              systemConfig = [ ./system ];
              hmUsers = users;
            };
        };
    in
      # - END CONFIG -
      {
        # Configuration is done at this point, and this is the logic that doesn't change often
        # used to build the actual flake outputs

        # * NixOS Configurations
        nixosConfigurations = util.makeSystemConfigurations hosts;

        # * deploy-rs outputs
        deploy.nodes = util.makeDeployNodes hosts;

        inherit hosts users util;
      };
}
