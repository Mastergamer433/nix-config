{ inputs, pkgs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      herbstluftwm.enable = true;
      autorandr = {
        enable = true;
      };
      apps = {
        discord.enable = true;
        polybar.enable = true;
        flameshot.enable = true;
        slock.enable = true;
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
      gaming = { flightgear.enable = false; };
    };
    editors = {
      emacs = {
        enable = true;
        daemonEnable = true;
      };
    };
    dev = {
      scheme.enable = true;
      common-lisp.enable = true;
    };
    hardware = { audio.enable = true; };
    shell = {
      fish.enable = true;
      starship.enable = true;
    };
  };

  ## Local config
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.10.10.6/24" ];
      privateKeyFile = config.age.secrets.wireguard.path;
      peers = [{ # doomemacs
        presharedKey = "XzXU4EkJxrZ2XFxiXuLy30nFo7tRh0/KT0ofys0iXwU=";
        publicKey = "tnwFMErFdkJWUh64+9n2e5K/SSIQoD1VNBfxYdIK3kg=";
        allowedIPs = [ "10.10.10.0/24" ];
        endpoint = "kimane.se:51820";
        persistentKeepalive = 25;
      }];
    };
  };

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
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
