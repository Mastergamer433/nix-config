{ config, lib, ... }:

with builtins;
with lib; {
  networking.extraHosts = ''
    192.168.1.1   router.home
    # Hosts
    ${optionalString (config.time.timeZone == "Europe/Copenhagen") ''
      192.168.1.28  ao.home
      192.168.1.20  murasaki.home
      192.168.1.19  shiro.home
    ''}
    ${optionalString (config.time.timeZone == "America/Toronto") ''
      192.168.1.2   ao.home
      192.168.1.3   kiiro.home
      192.168.1.10  kuro.home
      192.168.1.11  shiro.home
      192.168.1.12  midori.home
    ''}
  '';

  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "Europe/Stockholm";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
}
