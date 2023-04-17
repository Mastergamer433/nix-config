{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.kmonad;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.kmonad = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ haskellPackages.kmonad ];
    services.udev.extraRules = ''
        # KMonad user access to /dev/uinput
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      '';

    home.file = {
      ".config/kmonad" = {
        source = "${configDir}/kmonad";
        recursive = true;
      };
    };
  };
}
