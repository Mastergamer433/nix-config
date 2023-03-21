{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.backup;
  configDir = config.dotfiles.configDir;
in {
  options.modules.backup = with types; {
    enable = mkBoolOpt false;
    remotePath = mkOpt str "/mnt/backup/${config.networking.hostName}";
    remoteUser = mkOpt str "root";
    remoteIp = mkOpt str "192.168.21.228";
    sshKey = mkOpt str "/home/${config.user.name}/.ssh/id_backup";
    remoteScript = mkOpt str "/root/backup.sh";
  };

  config = mkIf cfg.enable {

    services.cron = {
      enable = true;
      systemCronJobs = [
        "0 12 * * * ${pkgs.writeShellScript "backup.sh" ''
rsync -avPqaHAXSgopEl -e "ssh -i ${cfg.sshKey}" /home ${cfg.remoteUser}@${cfg.remoteIp}:${cfg.remotePath}_home
ssh -i ${cfg.sshKey} ${cfg.remoteUser}@${cfg.remoteIp} "${cfg.remoteScript} ${config.networking.hostName}_home"
      ''}"
      ];
    };
  };
}
