{ lib, pkgs, ... }:
let
  profiles = "${pkgs.firejail}/etc/firejail/";
in {
  programs.firejail = {
    enable = true;

    wrappedBinaries = {
      signal-desktop= {
        executable = "${lib.getBin pkgs.signal-desktop}/bin/signal-desktop";
        profile = "${profiles}/signal-desktop.profile";
        desktop = "${pkgs.signal-desktop}/share/applications/signal.desktop";
      };

      spotify = {
        executable = "${lib.getBin pkgs.spotify}/bin/spotify";
        profile = "${profiles}/spotify.profile";
        desktop = "${pkgs.spotify}/share/applications/spotify.desktop";
      };
    };
  };
}
