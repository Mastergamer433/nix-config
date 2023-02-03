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
      };
    };
    user.packages = with pkgs; [
      rofi
      nitrogen
      conky
      dzen2
    ];

    home.file = {
      ".config/herbstluftwm" = {
        source = "${configDir}/herbstluftwm";
        recursive = true;
      };
    };
  };
}
