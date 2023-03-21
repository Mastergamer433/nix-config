{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.doom;
in {
  options.modules.desktop.gaming.doom = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;[
      crispyDoom

      (let launch-script =
        with pkgs; (writeScriptBin "launch-doom" ''
          #!${stdenv.shell}
          crispy-doom -iwad ~/DOOM/DOOM.WAD
        '');
      in launch-script)

    ];
  };
}
