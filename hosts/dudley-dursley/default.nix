{ inputs, pkgs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      herbstluftwm.enable = true;
      awesome.enable = true;
      autorandr = {
        enable = true;
      };
      wallpapers.enable = true;
      apps = {
        rofi.enable = true;
        discord.enable = true;
        polybar.enable = true;
        flameshot.enable = true;
        slock.enable = true;
        #kmonad.enable = true;
        sxhkd.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      media = { spotify.enable = true; };
      browsers = {
        nyxt.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
      };
      media = { mpv.enable = true; };
    };
    editors = {
      vim.enable = true;
      emacs = {
        enable = true;
        daemonEnable = true;
      };
    };
    dev = {
      scheme.enable = true;
      common-lisp.enable = true;
      nix.enable = true;
      lua.enable = true;
      rust.enable = true;
      fennel.enable = true;
    };
    hardware = { audio.enable = true; };
    shell = {
      fish = {
        enable = true;
        rcInit = ''
zoxide init fish | source
'';
      };
      zoxide.enable = true;
      starship.enable = true;
      pass.enable = true;
      gnupg.enable = true;
    };
    services = {
      git = {
        sync = {
          dotfiles.enable = true;
        };
      };
      docker.enable = true;
      ssh.enable = true;
      #arion.enable = true;
    };
  };

  ## Local config
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.10.10.6/24" "2001:470:de51:1010::6/64" ];
      privateKeyFile = config.age.secrets.wireguard.path;
      peers = [{ # doomemacs
        presharedKey = "XzXU4EkJxrZ2XFxiXuLy30nFo7tRh0/KT0ofys0iXwU=";
        publicKey = "tnwFMErFdkJWUh64+9n2e5K/SSIQoD1VNBfxYdIK3kg=";
        allowedIPs = [ "10.10.10.0/24" "::/0" ];
        endpoint = "kimane.se:51820";
        persistentKeepalive = 25;
      }];
    };
  };

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
  networking.nameservers = ["10.10.10.3" "1.1.1.1"];

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };

  boot = {
    loader = {
      grub.enable = true;
      grub.efiSupport = false;
      grub.device = "/dev/sda";
      efi = { canTouchEfiVariables = false; };
    };
  };
}
