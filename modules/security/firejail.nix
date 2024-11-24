{ lib, pkgs, ... }:
let
  profiles = "${pkgs.firejail}/etc/firejail/";
in {
  programs.firejail = {
    enable = true;

    wrappedBinaries = {
      spotify = {
        executable = "${lib.getBin pkgs.spotify}/bin/spotify";
        profile = "${profiles}/spotify.profile";
      };
    };
  };
}
