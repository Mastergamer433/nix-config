{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.browsers.qutebrowser;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.browsers.qutebrowser = with types; {
    enable = mkBoolOpt false;
    themeMode = mkOpt str "dark";
    userStyles = mkOpt lines "";
    extraConfig = mkOpt lines "";
    dicts = mkOpt (listOf str) [ "en-US" ];
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (makeDesktopItem {
        name = "qutebrowser-private";
        desktopName = "Qutebrowser (Private)";
        genericName = "Open a private Qutebrowser window";
        icon = "qutebrowser";
        exec =
          "${pkgs.qutebrowser}/bin/qutebrowser -T -s content.private_browsing true";
        categories = [ "Network" ];
      })
      # For Brave adblock in qutebrowser, which is significantly better than the
      # built-in host blocking. Works on youtube and crunchyroll ads!
      python39Packages.adblock
    ];
    home-manager.programs.qutebrowser = {
      enable = true;
      settings = {
        content = {
          default_encoding = "utf-8";
          javascript.enabled = true;
          local_storage = true;
          plugins = true;
          autoplay = false;
        };
        editor.encoding = "utf-8";
        colors = with config.scheme.withHashtag; {
          # Becomes either 'dark' or 'light', based on your colors!
          webpage.preferred_color_scheme = "${cfg.themeMode}";
          tabs.bar.bg = "${base00}";
          keyhint.fg = "${base05}";
          # ...
        };
      };
    };
  };
}
