{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.mysql;
in {
  options.modules.services.mysql = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [
        "awesomewm"
        "emacs"
      ];
      ensureUsers = [
        {
          name = "mg433";
          ensurePermissions = {
            "*.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };
}
