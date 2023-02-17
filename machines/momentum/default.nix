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
  boot.loader.grub.device = "/dev/sdb"; # or "nodev" for efi only

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/89d5ba16-7b83-4020-b959-b9f3726dd9ef";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BDC5-3C9B";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/89d5ba16-7b83-4020-b959-b9f3726dd9ef";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/89d5ba16-7b83-4020-b959-b9f3726dd9ef";
      fsType = "btrfs";
      options = [ "subvol=@var/log" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/89d5ba16-7b83-4020-b959-b9f3726dd9ef";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/root" =
    { device = "/dev/disk/by-uuid/89d5ba16-7b83-4020-b959-b9f3726dd9ef";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = (1024*16) + (2048);
    }
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
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
