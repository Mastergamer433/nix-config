{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.dunst;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.dunst = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home-manager.services.dunst = {
      enable = true;
      settings = with config.scheme.withHashtag; {
        global = {
          frame_color = "${base05}";
          separator_color = "${base05}";
          gap_size = 8;
          frame_width = 2;
        };

        block_spotify = {
          app_name = "spotify";
          format = "";
        };

        base16_low = {
          msg_urgency = "low";
          background = "${base01}";
          foreground = "${base03}";
        };

        base16_normal = {
          msg_urgency = "normal";
          background = "${base02}";
          foreground = "${base05}";
        };

        base16_critical = {
          msg_urgency = "critical";
          background = "${base08}";
          foreground = "${base06}";
        };
      };
    };
  };
}
