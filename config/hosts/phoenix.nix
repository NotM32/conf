{ inputs, ... }:
{
  imports = [
    "${inputs.conf.system.layersPath}/boot/uefi.nix"
  ];
}
