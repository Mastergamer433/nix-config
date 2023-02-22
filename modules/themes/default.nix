{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    scheme = mkOption {
      type = nullOr string;
      default = null;
      apply = v: let theme = builtins.getEnv "THEME"; in
      if theme != "" then theme else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable.
      '';
    };
  };

  config = mkIf (config.scheme != null) {
    home-manager.programs.alacritty.settings.colors =
      with config.scheme.withHashtag; let default = {
        black = base00; white = base07;
        inherit red green yellow blue cyan magenta;
      };
      in {
        primary = { background = base00; foreground = base07; };
        cursor = { text = base02; cursor = base07; };
        normal = default; bright = default; dim = default;
      };
  };
}
