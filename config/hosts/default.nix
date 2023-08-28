{ self, nur, ... }:
let
  users.m32 = import ../config/home.nix;
in {
  nixosConfigurations = self.lib.system.makeSystemConfigurations { # ** Hosts
    # Desktop
    phoenix = {
      hardwareProfile = ./hardware/ryzen_desktop.nix;
      systemConfig = [ # Bootloader and Disks specific to this system
        ./system/boot/uefi.nix

        # Repos
        nur.nixosModules.nur

        # More userlandish profile
        ./system/october.nix

        # Others
        ./system/X/remap_mac_keys.nix

      ];
      inherit users;
    };

    # T430 laptop
    momentum = {
      hardwareProfile = ./hardware/t430.nix;
      systemConfig = [ # Bootloader
        ./system/boot/legacyboot.nix

        # Repos
        nur.nixosModules.nur

        # Same shit, different story
        ./system/october.nix

        # Need to find a way TODO this on a per keeb basis
        ./system/X/remap_mac_keys.nix
      ];
      inherit users;
    };

    # Server
    maple = {
      hardwareProfile = ./hardware/ovh_vps.nix;
      systemConfig = [ ./system/server.nix ];
    };

  };
}
