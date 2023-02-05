{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.nyxt;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.browsers.nyxt = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nyxt
      gst
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-base
      
    ];

    home = {
      configFile = {
        "nyxt" = {
          source = "${configDir}/nyxt";
          recursive = true;
        };
      };
    };
  };
}
