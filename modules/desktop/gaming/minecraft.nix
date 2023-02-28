{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.minecraft;
in {
  options.modules.desktop.gaming.minecraft = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      prismlauncher
    ];
    programs.java.enable = true;
  };
}
