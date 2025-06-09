{ pkgs, config, lib, ... }: {
  security.pam.services = {
    login = {
      oathAuth = true;
      u2fAuth = true;

      rules.auth = with config.security.pam.services.login.rules; {
        unix = { control = lib.mkForce "required"; };
        u2f = {
          control = lib.mkForce "sufficient";
          order = auth.unix.order + 10;
        };
        oath = {
          control = lib.mkForce "sufficient";
          order = auth.u2f.order + 10;
        };
      };
    };

    sudo.u2fAuth = true;
    sshd.oathAuth = true;
  };

  security.pam.u2f.settings = {
    cue = true;
    interactive = true;
    authfile = config.sops.secrets."u2f-mappings".path;
  };


  # Yubikey u2f Udev packages and rule to lock screen
  services.udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host ];
  services.udev.extraRules = ''
    ACTION=="remove",\
     ENV{ID_BUS}=="usb",\
     ENV{ID_MODEL_ID}=="0407",\
     ENV{ID_VENDOR_ID}=="1050",\
     ENV{ID_VENDOR}=="Yubico",\
     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  # OATH HOTP/TOTP
  sops.secrets."oath" = {
    sopsFile = ../../secrets/auth.yml;

    owner = "root";
    group = "root";
    mode = "0600";
    path = "/etc/users.oath";
  };

  # U2F User Mappings - override home directory file
  sops.secrets."u2f-mappings" = {
    sopsFile = ../../secrets/auth.yml;

    owner = "root";
    group = "root";
    mode = "0600";
    path = "/etc/u2f-mappings";
  };
}
