{ config, ... }: {
  pam.sessionVariables = { EDITOR = "emacsclient"; };

  pam.yubico.authorizedYubiKeys.ids = [ "ccccccvedkdn" ];

  sops.secrets.pamu2fcfg = {
    path = "${config.home.homeDirectory}/.config/Yubico/u2f_keys";
  };
}
