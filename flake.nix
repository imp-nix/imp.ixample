{
  description = "NixOS + Home Manager configuration using imp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    imp.url = "git+file:./tmp/imp";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      imp,
      flake-utils,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
      args = {
        inherit
          self
          inputs
          imp
          lib
          nixpkgs
          home-manager
          flake-utils
          treefmt-nix
          pkgsFor
          ;
      };
    in
    imp.treeWith lib (f: f args) ./outputs
    // {
      nixosModules = {
        default = imp ./modules/nixos;
        profiles = imp ./modules/profiles;
      };

      homeModules = {
        default = imp ./modules/home;
      };

      overlays.default = final: prev: {
        ix = self.packages.${prev.system} or { };
      };
    };
}
