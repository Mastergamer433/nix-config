{ pkgs, inputs, config, lib, ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];
  ## Modules
  modules = {
    desktop = {
      wallpapers.enable = true;
      herbstluftwm.enable = true;
      xmonad.enable = true;
      awesome.enable = true;
      dwm.enable = true;
      bspwm.enable = true;
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
      };
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
      #mysql.enable = true;
      docker.enable = true;
    }; 
    backup.enable = true;
  };
  ## Local config
  #networking.wireguard.interfaces = {
  #  wg0 = {
  #    ips = [ "10.81.92.3/24" "2600:70ff:b165:8192::3/64" ];
  #    privateKeyFile = config.age.secrets.wireguard.path;
  #    peers = [
 #       { 
  #      publicKey = "VyY1kJ1AjvMpJUvu0g1dKrdKp+49/z6lGghe78nB6Cc=";
  #      allowedIPs = [ "10.81.92.0/24" "::/0" ];
  #      endpoint = "kimane.se:3010";
  #      persistentKeepalive = 25;
  #      }
  #    ];
  #  };
  #};
  networking.nameservers = ["10.1.10.72" "1.1.1.1"];
  environment.systemPackages = with pkgs; [ feh ntfs3g dmenu pcmanfm teams pkgs.cifs-utils libnotify ];
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = ["10.1.10.72" "1.1.1.1"];
  networking.networkmanager.dns = "none";
  services.gvfs.enable = true;
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
  networking.extraHosts = ''
    192.168.1.1   router.home
    # Hosts
    84.216.24.189 virtualmin.kimane.se
  '';

}
