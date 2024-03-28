{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];

  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" =
    { device = "/dev/sda3";
      fsType = "ext4";
    };

  # OVH VPS has /dev/vram0
  zramSwap.enable = true;

  boot.tmp.cleanOnBoot = true;
}
