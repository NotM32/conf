{ pkgs, ... }:
{
  services.gitea = {
    enable = true;
    # gitea server, served on a unix socket. publicly accessed by the nginx reverse proxy
    appName = "git.m32";
    # not used if listening on local unix socket
    #httpAddress = "127.0.0.1";
    #httpPort = 3000;
    stateDir = "/srv/gitea/";
    lfs.enable = true;

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
          DISABLE_REGISTRATION = true;
        };
      "server" =
        { OFFLINE_MODE = true;
          DISABLE_SSH  = false;
          ROOT_URL = "https://git.m32.me/";
          DOMAIN = "git.m32.me";
          PROTOCOL = "http+unix";
        };
      "picture" =
        { AVATAR_MAX_FILE_SIZE = 5242880; };
      "session" =
        { COOKIE_SECURE = true; };
      "actions" =
        { ENABLED = true; };

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

  # Actions Runner --
  environment.systemPackages = with pkgs; [ gitea-actions-runner ];


}
