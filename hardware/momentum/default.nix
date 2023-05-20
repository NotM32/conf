{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "evdi" ];
  boot.extraModulePackages = [ ];

  # The "superbay" shows up first...
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];# or "nodev" for efi only

  fileSystems."/" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BDC5-3C9B";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=@var/log" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/root" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  swapDevices = [
    # {
    #   device = "/swap/swapfile";
    #   size = (1024*16) + (2048);
    # }
    { device = "/dev/disk/by-uuid/4399ebf3-a41a-4ced-b6c8-961faaeb8ed0"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  hardware.bluetooth.enable = true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Keyboard / Mouse
  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };
}
