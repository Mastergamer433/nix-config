{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.alacritty;
in {
  options.modules.desktop.term.alacritty = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home-manager.programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "Fira Code";
          size = 10;
        };
        window = {
          opacity = 0.6;
          dynamic_title = true;
        };
        draw_bold_text_with_bright_colors = true;
        bell = {
          animation = "EaseOutExpo";
          duration = 10;
        };
        cursor.style.blinking = "On";
        mouse.hide_when_typing = true;
      };
    };
  };
}
