{
  description = "NixOS + Home Manager configuration using imp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    imp.url = "github:Alb-O/imp";
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
    in
    {
      nixosConfigurations = {
        workstation = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # config/ subdirectory handled by configTree in default.nix
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/workstation)
            (imp ./modules/nixos)
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.alice = import ./home/alice;
              };
            }
          ];
        };

        server = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/server)
            (imp ./modules/nixos)
            # Only include server-specific profiles
            ((imp.withLib lib).filter (lib.hasInfix "/server/") ./modules/profiles)
          ];
        };

        # Run with: nix run .#apps.x86_64-linux.vm
        vm = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/vm)
            (imp ./modules/nixos)
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.alice = import ./home/alice;
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "alice@workstation" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            (imp ./home/alice)
            (imp ./modules/home)
          ];
        };
      };

      nixosModules = {
        default = imp ./modules/nixos;
        profiles = imp ./modules/profiles;
      };

      homeModules = {
        default = imp ./modules/home;
      };
    }
    # Per-system outputs from ./outputs directory
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        args = {
          inherit
            self
            pkgs
            inputs
            treefmt-nix
            ;
        };
      in
      imp.treeWith lib (f: f args) ./outputs
    )
    // {
      overlays.default = final: prev: {
        ix =
          let
            pkgs = nixpkgs.legacyPackages.${prev.system};
            args = {
              inherit
                self
                pkgs
                inputs
                treefmt-nix
                ;
            };
          in
          (imp.treeWith lib (f: f args) ./outputs).packages or { };
      };
    };
}
