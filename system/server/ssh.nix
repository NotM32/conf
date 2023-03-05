{ config, lib, pkgs, ... }:
{
  openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };
}
