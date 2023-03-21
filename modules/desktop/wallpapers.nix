{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.wallpapers;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.wallpapers = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ nitrogen ];

    home.file = {
      ".wallpapers/" = {
        source = "${configDir}/wallpapers/";
        recursive = true;
      };
    };
  };
}
