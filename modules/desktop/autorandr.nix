{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.autorandr;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.autorandr = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.autorandr = {
      enable = true;
      profiles = {
        projector = {
          config = {
            "HDMI-1" = {
              enable = true;
              mode = "1920x1080";
              position = "0x0";
              rate = "60.00";
              crtc = 1;
            };
            "eDP-1" = {
              enable = true;
              mode = "1366x768";
              position = "1920x0";
              primary = true;
              rate = "60.06";
            };
          };
          fingerprint = {
            HDMI-1 =
              "00ffffffffffff0038a3887c010101012f1e0103800000782a81cca25b5b9c231250602129008140a940614081009040b300d1c095009e20009051201f304880360000000000001a9e20009051201f304880360000000000001a000000fd0018550f641e000a202020202020000000fc004e502d4d45333833570a20202001010203287152010203111284130514101f20212206071516230907076c030c0020008021c010011801023a801871382d40582c450000000000001e662156aa51001e30468f330000000000001e011d007251d01e206e28550000000000001e0e1f008051001e304080370000000000001c00000000000000000000000000000099";
              eDP-1 =
                "00ffffffffffff0006af2c310000000000150104901d10780215859758538a2625505400000001010101010101010101010101010101ce1d56e250001e302616360025a410000018df1356e250001e302616360025a41000001800000000000000000000000000000000000000000002000c48ff0a3c640f0f1a6420202000f4";
          };
        };
        mobile = {
          config = {
            "eDP-1" = {
              enable = true;
              mode = "1366x768";
              primary = true;
              position = "0x0";
              rate = "60.00";
            };
            "HDMI-1" = { enable = false; };
          };
          fingerprint = {
            eDP-1 =
              "00ffffffffffff0006af2c310000000000150104901d10780215859758538a2625505400000001010101010101010101010101010101ce1d56e250001e302616360025a410000018df1356e250001e302616360025a41000001800000000000000000000000000000000000000000002000c48ff0a3c640f0f1a6420202000f4";
          };
        };
      };
      hooks.postswitch = {
        "notify-herbstluftwm" = "${pkgs.herbstluftwm}/bin/herbstclient detect_monitors";
        "notify-user" = ''
          notify-send "Autorandr: Changed profile to: $AUTORANDR_CURRENT_PROFILE"
        '';
      };
    };
    user.packages = with pkgs; [ libnotify ];
services.udev.extraRules = ''ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr -c"'';
  };
}
