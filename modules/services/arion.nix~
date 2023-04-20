{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.arion;
in {
  options.modules.services.arion = {
    enable = mkBoolOpt false;
    projects = mkOpt {};
  };

  config = mkIf cfg.enable {
    modules.services.docker.enable = true;
    virtualisation.arion = {
      backend = "docker";
      projects = cfg.projects;
    };  
  };
}
