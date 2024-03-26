{ ... }:
{
  # Automatic Upgrades / Configuration sync
  system.autoUpgrade = {
    enable = true;
    flake = "m32conf";
    flags = [
      "--impure" #TODO: remove the things that make this flake evaluate impurely
    ];
  };
}
