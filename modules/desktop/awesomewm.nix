
{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.awesome;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.awesome = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.desktop.xorg.enable = true;
    services = {
      picom.enable = true;
      picom.vSync = true;
      picom.settings = {
        unredir-if-possible = false;
      };
      picom.backend = "glx";
      xserver = {
        windowManager.awesome = {
          enable = true;
          luaModules = with pkgs.luaPackages; [
            luarocks # is the package manager for Lua modules
            luadbi-mysql # Database abstraction layer
          ];
        };
      };
    };
    user.packages = with pkgs; [ nitrogen conky dzen2 ];

    home.file = {
      ".config/awesome/" = {
        source = "${configDir}/awesome/";
        recursive = true;
      };
    };
  };
}
