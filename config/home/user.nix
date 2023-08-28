# * Not a home-manager config - this is inserted into the users.users config
{ lib, ... }:
{
  users.users.m32 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" ];
    openssh.authorizedKeys.keyFiles =
      builtins.map (value: "./ssh/" + value) builtins.attrNames
      lib.attrsets.filterAttrs (name: value: value == "regular")
      builtins.readDir ./ssh;
  };
}
