{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = v: let theme = builtins.getEnv "THEME"; in
      if theme != "" then theme else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable.
      '';
    };
  };

  config = mkIf (cfg.active != null) {
      home-manager.programs.alacritty.settings.colors =
        with "${inputs.base16-schemes}/${config.modules.theme.active}.yaml".withHashtag; let default = {
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
