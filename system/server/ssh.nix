{ config, lib, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    PermitRootLogin = "no";
    PasswordAuthentication = false;
  };
}
