{ self, ... }:
with self.inputs.nixpkgs.lib;
let
  # Function to create an overridable nixosSystem
  nixosSystem = makeOverridable self.inputs.nixpkgs.lib.nixosSystem;

  # List of .nix files in './hosts'
  nixosConfigurations = mapAttrs' (name: value:
    # call nixosSystem for each host in the './hosts/' directory
    let
      system = nixosSystem {
        # self will always infinite recursion when used in module imports, so must be passed as specialArgs to access nixosModules
        specialArgs = { inherit self; };

        modules = [ { _module.args = { inherit self; } // self.inputs; } # making self and inputs available to modules
                    (./. + "/hosts/${name}") # importing the host config
                  ];
      };
    in nameValuePair
      (system.config.networking.hostName)
      (system))
    # list host configurations from ./hosts/
    (filterAttrs
      (attr: value: value == "regular" && hasSuffix ".nix" attr)
      (builtins.readDir ./hosts));

in {
  flake = { inherit nixosConfigurations; };
}
