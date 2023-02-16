{ inputs, util, ... }:
let
  deploy = inputs.deploy;
in
rec {
  makeDeployNode = {deployUser ? "root", system ? "x86_64-linux", hostname ? "nixos", nixosSystem, ...}:
    {
      "${hostname}".profiles = {
        profiles = {
          hardware = {
            path = deploy.lib."${system}".activate.nixos nixosSystem;
          };

          system = {

          };

          home = {

          };
        };
      };
    };

  makeDeployNodes = hosts: nixosConfigurations:
    builtins.mapAttrs (hostName: hostConfig:
      makeDeployNode (hostConfig // { inherit hostName;
                                      nixosSystem = nixosConfigurations."${hostName}";
                                    })
    ) hosts;
}
