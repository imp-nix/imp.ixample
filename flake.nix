{
  description = "NixOS + Home Manager configuration using imp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    imp.url = "github:Alb-O/imp";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      imp,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;

      # Supported systems for per-system outputs
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper to generate per-system attrs
      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # Build per-system outputs using imp.treeWith
      perSystemOutputs = forAllSystems (
        pkgs:
        imp.treeWith lib (f: f { inherit self pkgs inputs; }) ./outputs
      );

      # Merge per-system outputs into flake structure
      mergePerSystem =
        attr:
        lib.genAttrs systems (system: perSystemOutputs.${system}.${attr} or { });
    in
    {
      # NixOS configurations - each host imports modules via imp
      nixosConfigurations = {
        # Example workstation host
        workstation = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Import host modules, excluding config/ (handled by configTree in default.nix)
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/workstation)

            # Import shared NixOS modules
            (imp ./modules/nixos)

            # Home Manager as NixOS module
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

        # Example server host
        server = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Import host modules, excluding config/
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/server)
            (imp ./modules/nixos)

            # Server uses imp filtering for selective modules
            (
              let
                i = imp.withLib lib;
              in
              i.filter (lib.hasInfix "/server/") ./modules/profiles
            )
          ];
        };

        # QEMU VM for testing
        vm = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Import host modules, excluding config/
            ((imp.withLib lib).filterNot (lib.hasInfix "/config/") ./hosts/vm)
            (imp ./modules/nixos)

            # Include Home Manager in VM for testing
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

      # Standalone Home Manager configurations
      homeConfigurations = {
        "alice@workstation" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            # Import all home modules via imp
            (imp ./home/alice)
            (imp ./modules/home)
          ];
        };
      };

      # Per-system outputs loaded via imp.treeWith
      packages = mergePerSystem "packages";
      devShells = mergePerSystem "devShells";
      apps = mergePerSystem "apps";

      # NixOS modules exposed for external use
      nixosModules = {
        default = imp ./modules/nixos;
        profiles = imp ./modules/profiles;
      };

      # Home Manager modules exposed for external use
      homeModules = {
        default = imp ./modules/home;
      };

      # Overlay combining all packages
      overlays.default = final: prev: {
        ix = perSystemOutputs.${prev.system}.packages or { };
      };
    };
}
