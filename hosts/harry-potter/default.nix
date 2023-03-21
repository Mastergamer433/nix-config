{ pkgs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];
  ## Modules
  modules = {
    desktop = {
      wallpapers.enable = true;
      herbstluftwm.enable = true;
      xmonad.enable = true;
      awesome.enable = true;
      apps = {
        discord.enable = true;
        polybar.enable = true;
        flameshot.enable = true;
        rofi.enable = true;
        slock.enable = true;
        dbeaver.enable = true;
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
        doom.enable = true;
      };
      vm = {
        qemu.enable = true;
      };
    };
    editors = {
      emacs = {
        enable = true;
        daemonEnable = true;
      };
    };
    dev = {
      lua.enable = true;
      scheme.enable = true;
      fennel.enable = true;
      rust.enable = true;
    };
    shell = {
      fish.enable = true;
      starship.enable = true;
    };
    hardware = {
      audio.enable = true;
      nvidia.enable = true;
    };
    services = {
      ssh.enable = true;
      #syncthing.enable = true;
    }; 
    backup.enable = true;
  };

  ## Local config
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.10.10.2/24" "2001:470:de51:1010::2/64" ];
      privateKeyFile = config.age.secrets.wireguard.path;
      peers = [
        { 
        publicKey = "tnwFMErFdkJWUh64+9n2e5K/SSIQoD1VNBfxYdIK3kg=";
        allowedIPs = [ "10.10.10.0/24" "::/0" ];
        endpoint = "kimane.se:51820";
        persistentKeepalive = 25;
        }
      ];
    };
  };
  networking.nameservers = ["192.168.21.228" "1.1.1.1"];
  environment.systemPackages = with pkgs; [ ntfs3g dmenu ];
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

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
