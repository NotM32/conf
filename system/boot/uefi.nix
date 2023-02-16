{ config, pkgs, ... }:
{
  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable     = true;
    device     = "nodev";
    efiSupport = true;
    configurationLimit = 5;
    theme      = pkgs.breeze-grub;

    # won't work with just this FYI, there's a confirmation option for TPM
    # trustedBoot.enable = true;
  };
}
