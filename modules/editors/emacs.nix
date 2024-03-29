{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.emacs;
  pkg = (pkgs.emacsWithPackagesFromUsePackage {
    package =
      pkgs.emacs; # replace with pkgs.emacsPgtk, or another version if desired.
    config = /. + builtins.toPath "${configDir}/emacs/Emacs.org";
    # config = path/to/your/config.org; # Org-Babel configs also supported

    alwaysEnsure = true;

    alwaysTangle = true;
    # Optionally provide extra packages not in the configuration file.
    extraEmacsPackages = epkgs: [ epkgs.use-package ];

  });
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    daemonEnable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    user.packages = with pkgs; [
      pkg
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity
      fd
      imagemagick
      (mkIf (config.programs.gnupg.agent.enable) pinentry_emacs)
      zstd
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      sqlite
      mu
      sbcl
      haskell-language-server
      pandoc
    ];

    home-manager.systemd.user.services."emacs" = mkIf cfg.daemonEnable {
      Unit.Description = "GNU Emacs daemon";
      Unit.Documentation = [ "man:emacs(1)" ];
      Install.WantedBy = [ "default.target" ];
      Service = {
        Type = "forking";
        ExecStart = ''${pkgs.runtimeShell} -l -c "${pkg}/bin/emacs --daemon"'';
        ExecStop = ''
          ${pkgs.runtimeShell} -l -c "${pkg}/bin/emacsclient --eval \"(kill-emacs)\""'';
        Restart = "on-failure";
      };
    };

    home.file = {
      ".emacs.d/" = {
        source = "${configDir}/emacs/";
        recursive = true;
      };
    };
    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts pkgs.fira-code ];
  };
}
