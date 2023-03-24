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
            french-dictionary
            ghosttext
            gloc
            ipvfoo
            languagetool
            modrinthify
            reddit-enhancement-suite
            react-devtools
            reddit-comment-collapser
            reddit-moderator-toolbox
            redirector
            refined-github
            swedish-dictionary
            tab-reloader
            tab-retitle
            tabcenter-reborn
            forget_me_not
            behave
            auto-tab-discard
            (mkIf (config.scheme.slug == "dracula") dracula-dark-colorscheme)
          ];
        };
      };
    };
  };
}
