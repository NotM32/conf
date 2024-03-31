{ self, deploy, ... }:
{
  makeDeployNode = {deployUser ? "root", system ? "x86_64-linux", hostName ? "nixos", remoteBuild ? false, nixosSystem, ...}:
    {
      inherit remoteBuild;

      user = deployUser;

      profiles = {
        # hardware = { };

        system = {
          path = deploy.lib."${system}".activate.nixos nixosSystem;
        };

        # home = { };

      };
    };

  makeDeployNodes = hosts: nixosConfigurations:
    builtins.mapAttrs (hostName: hostConfig:
      self.lib.deploy.makeDeployNode (hostConfig // { inherit hostName;
                                      nixosSystem = nixosConfigurations."${hostName}";
                                    })
    ) hosts;
}
