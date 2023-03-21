{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.xmonad;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.xmonad = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.desktop.xorg.enable = true;
    services = {
      picom.enable = true;
      picom.vSync = true;
      picom.settings = {
        unredir-if-possible = false;
      };
      picom.backend = "glx";
      xserver.windowManager.xmonad.enable = true;
      xserver.windowManager.xmonad.enableContribAndExtras = true;
    };
    user.packages = with pkgs; [ nitrogen conky dzen2 ];

    home.file = {
      ".xmonad/" = {
        source = "${configDir}/xmonad/";
        recursive = true;
      };
    };
  };
}
