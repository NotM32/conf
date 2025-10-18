{ pkgs, lib, ... }: {
  services.protonmail-bridge.enable = false;

  accounts.email = {
    maildirBasePath = ".mail";
    accounts.protonmail = {
      address = "m32@protonmail.com";
      gpg = {
        key = "DE0FE946DDA34B3BD1F92D59E017AC29E321";
        signByDefault = true;
      };
      imap.host = "127.0.0.1";
      imap.port = 1143;
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      msmtp.tls.fingerprint =
        "77:A7:DD:F5:8F:F6:E2:6B:6A:F0:52:29:3C:06:35:0A:23:CE:A1:2D:C8:47:BF:B4:6A:78:08:E5:D8:26:D6:30";
      notmuch.enable = true;
      primary = true;
      realName = "Riley C. O'Connor";
      signature = {
        text = ''
          Thanks,
          Riley C. O'Connor
        '';
        showSignature = "append";
      };
      passwordCommand =
        "${pkgs.gnupg}/bin/gpg -q -d ~/.authinfo.gpg | awk 'FNR == 5 {print $8}'";
      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls.useStartTls = true;
      };
      userName = "m32@protonmail.com";
    };
    # certificatesFile = ".config/protonmail/bridge/cert.pem";
  };

  programs.mbsync.enable = true;
  programs.msmtp = {
    enable = true;
    configContent = lib.mkAfter ''
      defaults
      tls_trust_file /home/m32/.config/protonmail/bridge/cert.pem
    '';
  };
  programs.notmuch = {
    enable = true;
    hooks = { preNew = "mbsync --all"; };
  };

  home.file.".mbsyncrc" = { source = ./mbsyncrc; };

  services.mbsync = {
    enable = false;
    configFile = ./mbsyncrc;
  };

}
