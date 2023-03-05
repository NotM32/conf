{ config, lib, pkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "compliance@m32.me";
    };
  };
}
