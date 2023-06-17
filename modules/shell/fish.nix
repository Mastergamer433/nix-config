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
    programs.fish.enable = true;
    home-manager.programs.fish = {
      enable = true;
      interactiveShellInit = 
      let aliasLines = mapAttrsToList (n: v: "alias ${n}=\"${v}\"") cfg.aliases;
      in ''
        base16-${config.scheme.slug}
        ${concatStringsSep "\n" aliasLines}
        ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
        ${cfg.rcInit}
      '';
      plugins = [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
            sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
        }
        {
          name = "base16-fish";
          src = pkgs.fetchFromGitHub {
            owner = "tomyun";
            repo = "base16-fish";
            rev = "2f6dd973a9075dabccd26f1cded09508180bf5fe";
            sha256 = "142fmqm324gy3qsv48vijm5k81v6mw85ym9mmhnvyv2q2ndg5rix";
          };
        }
      ];
    };

    user.packages = with pkgs; [
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


    };

    system.userActivationScripts.cleanupZgen = ''
      rm -rf $ZSH_CACHE
      rm -fv $ZGEN_DIR/init.zsh{,.zwc}
    '';
  };
}
