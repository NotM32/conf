{ pkgs, ... }:
let
  genu2fscript =
    pkgs.writeScript "" ''
    #!/bin/sh

    if [ ! -f "$HOME/.config/Yubico/u2f_keys" ]; then
       echo "Generating u2f_keys file..."
       mkdir -p $HOME/.config/Yubico/
       ${pkgs.pam_u2f}/bin/pamu2fcfg > $HOME/.config/Yubico/u2f_keys
    else
      echo "u2f_keys already exists, not replacing"
    fi
    '';
in {
  # ## Pam Auth w/ YubiKey (OTP/chal-resp not U2F)
  pam.yubico.authorizedYubiKeys.ids = [ "ccccccvedkdn" ];

  systemd.user.services.create-yubico-pam-u2f = {
    Unit = {
      Description = "Generates the user's u2f_keys file for use with local PAM auth";

    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${genu2fscript}";
      Restart = "no";
    };
  };
}
