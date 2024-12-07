{ pkgs,  ... }:
{
  imports = [ ./protonmail-bridge.nix ];

  services.protonmail-bridge.enable = true;

  accounts.email = {
    maildirBasePath = ".mail";
    accounts.protonmail = {
      address = "m32@protonmail.com";
      gpg = {
        key = "DE0FE946DDA34B3BD1F92D59E017AC29E321";
        signByDefault = true;
      };
      imap.host = "127.0.0.1";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
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
      passwordCommand = "${pkgs.gnupg}/bin/gpg -q -d ~/.authinfo.gpg | awk 'FNR == 1 {print $8}'";
      smtp = {
        host = "127.0.0.1";
      };
      userName = "m32@protonmail.com";
    };
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  home.file.".mbsyncrc" = {
    source = ./mbsyncrc;
  };

  services.mbsync = {
    enable = true;
    configFile = ./mbsyncrc;
  };

}
