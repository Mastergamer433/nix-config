{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.git.sync.dotfiles;
    pkg = pkgs.writeShellScriptBin "sync-dotfiles" ''
git --git-dir=/home/${config.user.name}/.dotfiles/.git --work-tree=/home/${config.user.name}/.dotfiles add .
git --git-dir=/home/${config.user.name}/.dotfiles/.git --work-tree=/home/${config.user.name}/.dotfiles stash
git --git-dir=/home/${config.user.name}/.dotfiles/.git --work-tree=/home/${config.user.name}/.dotfiles pull
git --git-dir=/home/${config.user.name}/.dotfiles/.git --work-tree=/home/${config.user.name}/.dotfiles stash apply
git --git-dir=/home/${config.user.name}/.dotfiles/.git --work-tree=/home/${config.user.name}/.dotfiles commit -m "Automatic sync"
git --git-dir=/home/${config.user.name}/.dotfiles/.git --work-tree=/home/${config.user.name}/.dotfiles push
'';
in {
  options.modules.services.git.sync.dotfiles = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ pkg ];
    services.cron = {
      systemCronJobs = [
        "*/20 * * * * mg433 ${pkg}/bin/sync-dotfiles"
      ];
    };
  };
}
