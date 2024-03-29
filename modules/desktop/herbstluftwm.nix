{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.herbstluftwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.herbstluftwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.desktop.xorg.enable = true;
    services = {
      picom.enable = true;
      picom.vSync = true;
      picom.settings = {
        unredir-if-possible = false;
      };
      picom.backend = "glx";
      clipmenu.enable = true;
      xserver.windowManager.herbstluftwm.enable = true;
    };
    user.packages = with pkgs; [ nitrogen conky dzen2 devour ];

    home.file = {
      ".config/herbstluftwm" = {
        source = "${configDir}/herbstluftwm";
        recursive = true;
      };
    };
  };
}
