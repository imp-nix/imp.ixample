{
  description = "NixOS + Home Manager configuration using imp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    imp.url = "github:Alb-O/imp";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      imp,
      treefmt-nix,
      ...
    }:
    let
      lib = nixpkgs.lib;
      impLib = imp.withLib lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [ imp.flakeModules.default ];

      imp = {
        src = ./nix/outputs;
        args = {
          inherit
            self
            inputs
            lib
            nixpkgs
            home-manager
            treefmt-nix
            ;
          imp = impLib;
        };
      };

      flake = {
        nixosModules = {
          default = imp ./nix/modules/nixos;
          profiles = imp ./nix/modules/profiles;
        };

        homeModules = {
          default = imp ./nix/modules/home;
        };

        overlays.default = final: prev: {
          ix = self.packages.${prev.system} or { };
        };
      };
    };
}
