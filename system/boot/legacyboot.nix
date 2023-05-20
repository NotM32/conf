{ ... }:
{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  # Remember to set the boot device in the hardware conf!
}
