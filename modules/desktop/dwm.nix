{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.dwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.dwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.desktop.xorg.enable = true;
    nixpkgs.overlays = [
      (self: super: {
        dwm = super.dwm.overrideAttrs (oldAttrs: rec {
          src = /. + builtins.toPath "${configDir}/dwm";
        });
      })
    ];

    services = {
      picom.enable = true;
      picom.vSync = true;
      picom.settings = {
        unredir-if-possible = false;
      };
      picom.backend = "glx";
      xserver = {
        windowManager.dwm = {
          enable = true;
        };
      };
    };
    user.packages = with pkgs; [ nitrogen conky dzen2 ];
  };
}
