{ config, options, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.fish;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.fish = with types; {
    enable = mkBoolOpt false;

    aliases = mkOpt (attrsOf (either str path)) {};

    rcInit = mkOpt' lines "" ''
      Fish lines to be written to $XDG_CONFIG_HOME/fish/extraconfig.fish and sourced by
      $XDG_CONFIG_HOME/fish/config.fish
    '';

    rcFiles  = mkOpt (listOf (either str path)) [];
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.fish;

    programs.fish = {
      enable = true;
      promptInit = "";
    };

    user.packages = with pkgs; [
      zsh
      nix-zsh-completions
      bat
      exa
      fasd
      fd
      fzf
      jq
      ripgrep
      tldr
    ];

    env = {
      ZDOTDIR   = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
      ZGEN_DIR  = "$XDG_DATA_HOME/zgenom";
    };

    home.configFile = {
      # Write it recursively so other modules can write files to it
      "fish" = { source = "${configDir}/fish"; recursive = true; };

      # Why am I creating extra.zsh{rc,env} when I could be using extraInit?
      # Because extraInit generates those files in /etc/profile, and mine just
      # write the files to ~/.config/zsh; where it's easier to edit and tweak
      # them in case of issues or when experimenting.
      "fish/extraconfig.fish".text = with config.scheme;
      let aliasLines = mapAttrsToList (n: v: "alias ${n}=\"${v}\"") cfg.aliases;
      in ''
        ${concatStringsSep "\n" aliasLines}
        ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
        ${cfg.rcInit}
      '';

    };

    system.userActivationScripts.cleanupZgen = ''
      rm -rf $ZSH_CACHE
      rm -fv $ZGEN_DIR/init.zsh{,.zwc}
    '';
  };
}
