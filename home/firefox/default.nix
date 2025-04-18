{ pkgs, ... }: {

  programs.firefox = {
    enable = true;
    profiles.default = {

      search.default = "Startpage";
      search.force = true;
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }];

          icon =
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "NixOS Wiki" = {
          urls = [{
            template = "https://nixos.wiki/index.php?search={searchTerms}";
          }];
          icon = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nxw" ];
        };

        "Startpage" = {
          definedAliases = [ "@sp" ];
          urls = [{
            template = "https://www.startpage.com/sp/search";
            params = [{
              name = "query";
              value = "{searchTerms}";
            }];
          }];
        };

        "bing".metaData.hidden = true;
        "google".metaData.hidden = true;
        "amazondotcom-us".metaData.hidden = true;
        "ddg".metaData.hidden = true;
        "ebay".metaData.hidden = true;
        "wikipedia".metaData.hidden = true;
      };

      userChrome = ''
        #sidebar-header {
         display: none;
        }

        #TabsToolbar {
         display: none;
        }
      '';

      settings = {
        "browser.newtabpage.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "dom.event.clipboardevents.enabled" = true;
        "extensions.pocket.enabled" = false;
        "geo.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;

        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "network.prefetch-next" = false;
        "network.predictor.enabled" = false;

        # disable keybindiings
        "ui.key.menuAccessKeyFocuses" = false;
      };
    };
  };
}
