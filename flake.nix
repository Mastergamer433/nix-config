{
  description = "My nixos configuration.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Extras
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nur.url = "github:nix-community/nur";
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, agenix, emacs-overlay, nur, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true; # forgive me Stallman senpai
          overlays = extraOverlays ++ (lib.attrValues self.overlays);
        };
      pkgs = mkPkgs nixpkgs [ ];

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in {
      lib = lib.my;

      overlays = mapModules ./overlays import;

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };
    };
}
