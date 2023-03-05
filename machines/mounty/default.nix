{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];

  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" =
    { device = "/dev/sda1";
      fsType = "ext4";
    };
}
