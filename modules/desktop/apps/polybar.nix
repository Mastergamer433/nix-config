{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.polybar;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.polybar = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home.file.".config/polybar/" = {
      source = "${configDir}/polybar";
      recursive = true;
    };

    user.packages = with pkgs; [ polybar playerctl ];
  };
}
