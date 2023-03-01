{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.firefox;
thm = config.config.scheme;
in {
  options.modules.desktop.browsers.firefox = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nur.overlay ];

    home-manager.programs.firefox = {
      enable = true;
      profiles = {
        private = {
          isDefault = true;
          settings = {
            "general.autoscroll" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            ublock-origin
            i-dont-care-about-cookies
            gesturefy
            simple-tab-groups
            tab-session-manager
            tab-counter-plus
            edit-with-emacs
            darkreader
            (mkIf (config.scheme.slug == "dracula") dracula-dark-colorscheme)
          ];
        };
      };
    };
  };
}
