{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.arion;
in {
  options.modules.services.arion = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.services.docker.enable = true;
    virtualisation.arion = {
      backend = "docker";
      projects.project.settings = {
        imports = [ (/. + builtins.toPath "${toString ../../hosts}/${config.networking.hostName}/arion-compose.nix") ];
      };
    };  
  };
}
