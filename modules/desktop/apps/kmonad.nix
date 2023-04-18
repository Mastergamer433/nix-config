{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.kmonad;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.kmonad = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.kmonad = {
      enable = true; # disable to not run kmonad at startup
      keyboards.desktop = {
        device = "/dev/input/by-uid/usb-Kingston_HyperX_Alloy_FPS_Mechanical_Gaming_Keyboard-event-kbd";
        config = builtins.readFile "${configDir}/kmonad/config.kbd";
      };
	    # Modify the following line if you copied nixos-module.nix elsewhere or if you want to use the derivation described above
	    # package = import /pack/to/kmonad.nix;
    };
  };
}
