# * Configuration for hardware authentication and other security profile things
{ ... }:
{
  # Pam Auth w/ YubiKey (OTP/chal-resp not U2F)
  pam.yubico.authorizedYubiKeys.ids = [ "ccccccvedkdn" ];

  # U2F Pam Auth
  home.file."u2f_keys" = {
    # Generate this file with
    # `nix-shell -p pam_u2f` and `pamu2fcfg`
    target = ".config/Yubico/u2f_keys";
    source = ./pam/u2f_keys;
  };
}
