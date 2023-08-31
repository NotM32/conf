{ nixpkgs, ... }: {
  # This is a helper automation that exports all the hardware configuration files in
  # this directory as an attrset based on their filename, with the value/lambda ready
  # to be added to the nixos configurations.
  conf.hardware.profiles = with nixpkgs.lib;
    attrsets.mapAttrs' (name: value:
      attrsets.nameValuePair (strings.removeSuffix ".nix" name)
      (import ./${name})) (attrsets.filterAttrs
        (name: value: value == "regular" && name != "default.nix")
        (builtins.readDir ./.));
}
