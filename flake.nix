{
  description = "My nixos configuration.";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    base16.url = "github:SenchoPens/base16.nix";
    base16.inputs.nixpkgs.follows = "nixpkgs";
    arion.url = "github:hercules-ci/arion";

    base16-schemes = {
      url = "github:base16-project/base16-schemes";
      flake = false;
    };
    base16-rofi = {
      url = "github:jordiorlando/base16-rofi";
      flake = false;
    };

    # Extras
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nur.url = "github:nix-community/nur";
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, agenix, emacs-overlay, nur, kmonad, ... }:
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

      scheme = "dracula";

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in {

      lib = lib.my;

      overlays = mapModules ./overlays import;

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p {});

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules { inherit inputs; } import;

      nixosConfigurations = mapHosts ./hosts {
        scheme = "${inputs.base16-schemes}/${scheme}.yaml";
      };

    };
}
