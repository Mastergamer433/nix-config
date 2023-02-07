{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nur.overlay ];

    home-manager.programs.firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
        i-dont-care-about-cookies
      ];
      profiles = {
        private = {
          isDefault = true;
          settings = {
            "general.autoscroll" = true;
          };
        };
      };
    };
  };
}
