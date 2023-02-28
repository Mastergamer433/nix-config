{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.rofi;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.rofi = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home-manager.programs.rofi = {
      enable = true;
      theme = config.scheme inputs.base16-rofi;
      plugins = with pkgs; [ rofi-calc rofi-emoji haskellPackages.greenclip ];
    };

    user.packages = with pkgs; [ haskellPackages.greenclip clipmenu ];
  };
}
