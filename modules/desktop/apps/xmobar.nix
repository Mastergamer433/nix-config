{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.xmobar;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.xmobar = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home.file.".xmobarrc" = {
      source = "${configDir}/xmobar/xmobarrc";
    };

    user.packages = with pkgs; [ haskellPackages.xmobar ];
  };
}
