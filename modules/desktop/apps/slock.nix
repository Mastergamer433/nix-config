{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.slock;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.slock = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { programs.slock.enable = true; };
}
