{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.steam;
in {
  options.modules.desktop.gaming.steam = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    user.packages = with pkgs; [
      wineWowPackages.stable
      protontricks
      winetricks
      protonup
    ];
    hardware.xone.enable = true;
    environment.systemPackages = with pkgs; [ linuxKernel.packages.linux_zen.xone ];

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  };
}
