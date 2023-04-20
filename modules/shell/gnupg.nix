{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg = with types; {
    enable   = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.pcscd.enable = true;
    programs.gnupg.agent = {
      enable = true;
      pinentryFlavor = "qt";
    };

    user.packages = [
      pkgs.tomb
      (let tomb-encrypt =
        with pkgs; (writeScriptBin "tomb-encrypt" ''
          #!${stdenv.shell}
          tomb lock $1.tomb -k $1.tomb
        '');
      in tomb-encrypt)

      (let tomb-decrypt =
        with pkgs; (writeScriptBin "tomb-decrypt" ''
          #!${stdenv.shell}
          tomb lock $1
        '');
      in tomb-decrypt)
    ];
  };
}
