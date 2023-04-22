{ config, lib, pkgs, ... }:
{
  #########
  # Gitea #
  #########
  services.gitea = {
    enable = true;
    # gitea server, served on a unix socket. publicly accessed by the nginx reverse proxy
    appName = "git.m32";
    domain = "git.m32.me";
    rootUrl = "https://git.m32.me/";
    # not used if listening on local unix socket
    #httpAddress = "127.0.0.1";
    #httpPort = 3000;
    stateDir = "/srv/gitea/";
    lfs.enable = true;

    # socket location is hardcoded to `unix:/run/gitea/gitea.sock` with PROTOCOL as unix
    enableUnixSocket = true;

    settings = {
      "ui" = { THEMES = "auto,arc-green,darkred"; };
      "ui.meta" =
        { AUTHOR = "M32";
          DESCRIPTION = "m32's version control web interface";
          KEYWORDS = "";
        };
      "attachment" = { MAX_SIZE = 4096; };
      "repository.signing" =
        { SIGNING_KEY    = "default";
          SIGNING_NAME   = "m32 git system";
          SIGNING_EMAIL  = "git@m32.me";
          INITIAL_COMMIT = "always";
          WIKI           = "always";
          CRUD_ACTIONS   = "always";
          MERGES         = "always";
        };
      "security" =
        { INSTALL_LOCK = true; };
      "service" =
        { REQUIRE_SIGNIN_VIEW = true;
          DISALBE_REGISTRATION = true;
        };
      "server" =
        { OFFLINE_MODE = true;
          DISABLE_SSH  = true;
        };
      "picture" =
        { AVATAR_MAX_FILE_SIZE = 5242880; };
      "session" =
        { COOKIE_SECURE = true; };
    };
  };

  #################
  # Gitea - vhost #
  #################
  services.nginx.upstreams = {
    "gitea" = {
      servers = { "unix:/run/gitea/gitea.sock" = {};};
    };
  };

  services.nginx.virtualHosts."git.m32.me" = {
    serverName = "git.m32.me";

    forceSSL = true;
    enableACME = true;

    listen = [
      { addr = "51.222.14.217";
        port = 443;
        ssl = true;
      }
      { addr = "51.222.14.217";
        port = 80;
      }
    ];

    locations = {
      "/" = {
        # upstream should be defined
        proxyPass = "http://gitea";
      };
    };

  };
}
