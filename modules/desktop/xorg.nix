{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.xorg;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.xorg = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ xorg.xmodmap ];
    services.xserver = {
      screenSection = ''
        Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
        Option         "AllowIndirectGLXProtocol" "off"
        Option         "TripleBuffer" "on"
      '';

      enable = true;
      displayManager = {
        lightdm.enable = true;
        sessionCommands =
          "sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap ${configDir}/xmodmap/.Xmodmap";
      };
      layout = "se";
    };
  };
}
