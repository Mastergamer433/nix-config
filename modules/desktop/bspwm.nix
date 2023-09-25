{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.bspwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.bspwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.desktop.xorg.enable = true;
    services = {
      picom.enable = true;
      picom.vSync = true;
      picom.settings = {
        unredir-if-possible = false;
      };
      picom.backend = "glx";
      xserver.windowManager.bspwm = {
        enable = true;
        sxhkd.configFile = "${configDir}/sxhkdwm/sxhkdrc";
        configFile = "${configDir}/bspwm/bspwmrc";
      };
    };
    user.packages = with pkgs; [ nitrogen conky dzen2 devour ];
  };
}
