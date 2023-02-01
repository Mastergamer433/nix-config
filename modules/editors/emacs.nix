{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    user.packages = with pkgs; [
      (pkgs.emacsWithPackagesFromUsePackage {
        package =
          pkgs.emacs; # replace with pkgs.emacsPgtk, or another version if desired.
        config = /. + builtins.toPath "${configDir}/emacs/Emacs.org";
        # config = path/to/your/config.org; # Org-Babel configs also supported

        alwaysEnsure = true;

        alwaysTangle = true;
        # Optionally provide extra packages not in the configuration file.
        extraEmacsPackages = epkgs: [ epkgs.use-package ];

      })
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity
      fd
      imagemagick
      (mkIf (config.programs.gnupg.agent.enable) pinentry_emacs)
      zstd
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      sqlite
    ];
    home.file = { 
      ".emacs.d/init.el" = {
        source = "${configDir}/emacs/init.el";
         recursive = true;
      };
    };
    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  };
}
