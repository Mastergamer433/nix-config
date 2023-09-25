{ config, lib, ... }:

with builtins;
with lib; {
  networking.extraHosts = ''
    192.168.1.1   router.home
    # Hosts
    84.216.24.189 virtualmin.kimane.se
  '';

  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "Europe/Stockholm";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
}
