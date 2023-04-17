{ inputs, config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.rofi;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.mbsync = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home-manager.programs.mbsync = {
      enable = true;
    };

    home.file = {
      ".mbsyncrc".text = ''
IMAPAccount kimane
Host isp.zyner.net
User mg433@kimane.se
Pass "@4#8*2$@R4*#u66264"
SSLType IMAPS
CertificateFile /etc/ssl/certs/ca-certificates.crt

IMAPStore kimane-remote
Account kimane

MaildirStore kimane-local
Subfolders Verbatim
Path ~/Mail/
Inbox ~/Mail/inbox

Channel kimane
Master :kimane-remote:
Slave :kimane-local:
Patterns *
Create Both
SyncState *
'';
    };
  };
}
