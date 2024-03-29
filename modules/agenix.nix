{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let
  inherit (inputs) agenix;
  secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
  modules.shell.fish.aliases = {"agenix" = "agenix -i /home/mg433/.ssh/id_encrypt ";};
  age = {
    secrets = if pathExists secretsFile then
      mapAttrs' (n: _:
        nameValuePair (removeSuffix ".age" n) {
          file = "${secretsDir}/${n}";
          owner = mkDefault config.user.name;
        }) (import secretsFile)
    else
      { };
    identityPaths = [ "/home/mg433/.ssh/id_encrypt" ];
  };
}
