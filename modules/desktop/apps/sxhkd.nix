{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.sxhkd;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.sxhkd = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home-manager.services.sxhkd.enable = true;
  };
}
