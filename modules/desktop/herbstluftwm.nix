{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.herbstluftwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.herbstluftwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services = {
      picom.enable = true;
      xserver = {
        enable = true;
        displayManager = {
          lightdm.enable = true;
          #  lightdm.greeters.mini.enable = true;
        };
        windowManager.herbstluftwm.enable = true;
        layout = "se";
        xkbOptions = "ctrl:nocaps,ctrl:swapcaps";
      };
    };
    user.packages = with pkgs; [
      rofi
      nitrogen
      conky
      dzen2
    ];

    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xmodmap}/bin/xmodmap "${pkgs.writeText  "xkb-layout" ''
clear lock
clear control
keycode 66 = Control_L
add control = Control_L
add Lock = Control_R

''}'';
    home.file = {
      ".config/herbstluftwm" = {
        source = "${configDir}/herbstluftwm";
        recursive = true;
      };
    };
  };
}
