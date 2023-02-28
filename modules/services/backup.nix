
{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.backup;
in {
  options.modules.services.backup = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ urbackup-client ];
  };
}
