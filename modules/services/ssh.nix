{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = true;
      };
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "mg433"
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICoiE+DqG3s3aDpjYZsiLcoU+SDgnRaKP0Q3DWRvQB2B mg433@harry-potter" ]
      else [];
  };
}
