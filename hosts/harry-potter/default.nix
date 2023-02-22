{ pkgs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];
  ## Modules
  modules = {
    desktop = {
      herbstluftwm.enable = true;
      apps = {
        discord.enable = true;
        polybar.enable = true;
        flameshot.enable = true;
        rofi.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      browsers = {
        nyxt.enable = true;
        firefox.enable = true;
      };
      media = {
        mpv.enable = true;
        spotify.enable = true;
      };
      gaming = {
        steam.enable = true;
        flightgear.enable = true;
        minecraft.enable = true;
      };
      vm = {
        qemu.enable = true;
      };
    };
    editors = { emacs.enable = true; };
    dev = { scheme.enable = true; };
    hardware = {
      audio.enable = true;
      nvidia.enable = true;
    };
  };

  ## Local config
  #networking.wireguard.interfaces = {
  #  wg0 = {
  #    ips = [ "10.10.10.3/24" ];
  #    listenPort = 51820;
  #    privateKeyFile = config.age.secrets.wireguard.path;
  #    peers = [{ # doomemacs
  #      presharedKey = "7A7W7Whrc1SPhw4O+jOGR5Lo+zRFjS81nuOfGrKO6fs=";
  #      publicKey = "Vwqi4VfktCk6alMxwdHiOcEUEPRKUkL0fvbF1TmQRAU=";
  #      allowedIPs = [ "10.10.10.0/24" ];
  #      endpoint = "37.123.133.36:51820";
  #    }];
  #  };
  #};

  environment.systemPackages = with pkgs; [ ntfs3g ];
  programs.ssh.startAgent = true;
  #services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;

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
  boot = { loader = { grub = { device = "nodev"; }; }; };
}
