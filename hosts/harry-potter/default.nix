{ pkgs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];
  ## Modules
  modules = {
    desktop = {
      wallpapers.enable = true;
      herbstluftwm.enable = true;
      xmonad.enable = true;
      awesome.enable = true;
      dwm.enable = true;
      apps = {
        discord.enable = true;
        polybar.enable = true;
        flameshot.enable = true;
        rofi.enable = true;
        slock.enable = true;
        dbeaver.enable = true;
        mbsync.enable = true;
        element.enable = true;
        dunst.enable = true;
        #kmonad.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      browsers = {
        nyxt.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
        castor.enable = true;
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
      unity.enable = true;
    };
    shell = {
      fish = {
        enable = true;
        aliases = {
          "mpv" = "devour mpv";
          "feh" = "devour feh";
        };
luick-file-share      };
      starship.enable = true;
      pass.enable = true;
      gnupg.enable = true;
      file.enable = true;
      zoxide.enable = true;
    };
    hardware = {
      audio.enable = true;
      nvidia.enable = true;
    };
    services = {
      ssh.enable = true;
      #syncthing.enable = true;
      mysql.enable = true;
    }; 
    backup.enable = true;
  };
  ## Local config
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.81.92.2/24" "2001:470:de51:8192::2/64" ];
      privateKeyFile = config.age.secrets.wireguard.path;
      peers = [
        { 
        publicKey = "SuU29nPvFW2HncOcdVmLVWhd4O5GXQntmZ5Ob0eUdW8=";
        allowedIPs = [ "10.81.92.0/24" "192.168.21.0/24" "::/0" ];
        endpoint = "84.216.24.189:51820";
        persistentKeepalive = 25;
        }
      ];
    };
  };
  networking.nameservers = ["192.168.21.228" "1.1.1.1"];
  environment.systemPackages = with pkgs; [ ntfs3g dmenu pcmanfm teams pkgs.cifs-utils ];
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = ["192.168.21.228" "1.1.1.1"];
  networking.networkmanager.dns = "none";

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
