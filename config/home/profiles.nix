# * In this file, compose the different user home manager profiles from the modules
{ ... }: rec {
  all = [ "base" "development" "editors" "security" "web" "workstation" ];
  full = all;
  server = [ "base" "security" ];
}
