/** This final is the final layer of configuration and last comosition of roles, etc */
inputs@{ self, nixpkgs, home-manager, sops-nix, ... }:
let
  lib = nixpkgs.lib;

  hosts = {
    "phoenix" = {
      userProfile = { "m32" = self.conf.home.profiles."all"; };
      hwProfile = "ryzen_desktop";
      hostConfig = import ./phoenix.nix;
      systemRole = "workstation";
    };
  };

  hostModules =
    let
      getModules = { userProfile ? { }, hwProfile, hostName ? "system", systemRole ? "base", hostConfig ? { },  extraConfig ? {}, ... }: lib.lists.flatten [
        # Modules from Libraries
        # - Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        # - Secrets
        sops-nix.nixosModules.sops

        # Configuration Composition --
        # - NixOS user defintion
        self.conf.home.userConfig
        # - HM user defintion
        {
          home-manager.users = userProfile;
        }
        # - Hardware Profile
        self.conf.hardware.profiles.${hwProfile}
        # - Hostname Config
        { networking.hostName = hostName; }
        # - System Role
        import "${self.conf.system.rolesPath}/${systemRole}.nix"
        hostConfig
    ];
  in builtins.mapAttrs (hostName: value: getModules (value // {inherit hostName;})) hosts;

in {
  nixosConfigurations = builtins.mapAttrs (hostName: modules: lib.nixosSystem {
    inherit modules;

    specialArgs = {
      inherit inputs; # Share access to the flake inputs in the configuration.
      libm32 = self.lib; # Make this library available in the configuration.
    };
  }) hostModules;
}
