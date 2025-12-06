# Firefox with NUR extensions
#
# Demonstrates the __inputs + __functor pattern for modules requiring
# external flake inputs. The NUR overlay is applied locally via pkgs.extend
# to keep the dependency self-contained.
{
  __inputs = {
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    { inputs, ... }:
    {
      __module =
        { config, pkgs, ... }:
        let
          # Apply NUR overlay locally - avoids polluting global pkgs
          nurPkgs = pkgs.extend inputs.nur.overlays.default;
        in
        {
          programs.firefox = {
            enable = true;
            # Must use nurPkgs.firefox to match extension packages
            package = nurPkgs.firefox;

            profiles.${config.home.username} = {
              id = 0;
              isDefault = true;
              extensions.packages = with nurPkgs.nur.repos.rycee.firefox-addons; [
                ublock-origin
                darkreader
                bitwarden
              ];
              settings = {
                # Privacy defaults
                "browser.startup.homepage" = "about:blank";
                "browser.newtabpage.enabled" = false;
                "browser.urlbar.suggest.searches" = false;
              };
            };
          };

          # Set as default browser
          xdg.mimeApps.defaultApplications = {
            "text/html" = [ "firefox.desktop" ];
            "x-scheme-handler/http" = [ "firefox.desktop" ];
            "x-scheme-handler/https" = [ "firefox.desktop" ];
          };
        };
    };
}
