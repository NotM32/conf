{ config, lib, ... }:
{
  boot.kernelModules = [
    "kvm-amd"
    "nzxt-kraken3"
    "nct6775"
    "i2c-dev"
    "i2c-piix4"
  ];

  boot.initrd = {
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];

    kernelModules = [
      "dm-snapshot"
      "vfat"
      "usbhid"
    ];

    luks.devices = {
      "uroot" = {
        device = "/dev/disk/by-uuid/e245dbf3-1c20-4a16-8ac1-d45582a2abee";
        preLVM = true;
      };
      "uroot2" = {
        device = "/dev/disk/by-uuid/53243a77-1b78-49c3-8d26-ccb118c5a692";
        preLVM = true;
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
    fsType = "btrfs";
    options = [ "subvol=@,compress=zstd,noatime,autodefrag" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
    fsType = "btrfs";
    options = [ "subvol=@home,compress=zstd,noatime,autodefrag" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
    fsType = "btrfs";
    options = [ "subvol=@nix,compress=zstd,noatime,autodefrag" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
    fsType = "btrfs";
    options = [ "subvol=@persist,compress=zstd,noatime,autodefrag" ];
  };

  fileSystems."/srv" = {
    device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
    fsType = "btrfs";
    options = [ "subvol=@srv,compress=zstd,noatime,autodefrag" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
    fsType = "btrfs";
    options = [ "subvol=@var,compress=zstd,noatime,autodefrag" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
    fsType = "btrfs";
    options = [ "subvol=@var/log,compress=zstd,noatime,autodefrag" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C900-11F4";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/9e60cced-d0fc-4fc9-9093-421dfcadf101"; } ];

  hardware.bluetooth.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Hardware Temps
  programs.coolercontrol.enable = true;

  # Video Drivers / Hardware options
  services.xserver.videoDrivers = [
    "nvidia"
    "modesetting"
    "fbdev"
  ];

  hardware.nvidia.modesetting.enable = true;

  # rgb
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  # see i2c kernel modules enabled above
  hardware.i2c.enable = true;
}
