{ pkgs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      herbstluftwm.enable = true;
      apps = {
        discord.enable = true;
        polybar.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      media = { spotify.enable = true; };
      browsers = {
        nyxt.enable = true;
        firefox.enable = true;
      };
      media = { mpv.enable = true; };
      gaming = { flightgear.enable = false; };
    };

    editors = { emacs.enable = true; };
    hardware.audio.enable = true;
  };

  ## Local config
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.10.10.6/24" ];
      privateKeyFile = config.age.secrets.wireguard.path;
      peers = [{ # doomemacs
        presharedKey = "1ti/VLsS7qeJyQ3MtrUGuNn2Mue64zwwaSap3ma2RIU=";
        publicKey = "Vwqi4VfktCk6alMxwdHiOcEUEPRKUkL0fvbF1TmQRAU=";
        allowedIPs = [ "10.10.10.0/24" ];
        endpoint = "37.123.133.36:51820";
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
