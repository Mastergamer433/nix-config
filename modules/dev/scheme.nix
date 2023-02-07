{ options, lib, pkgs, config, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.scheme;
in {
  options.modules.dev.scheme = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      guile
    ];
  };

}
