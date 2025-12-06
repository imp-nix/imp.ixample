# Core inputs for imp flake operation
{
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  flake-parts.url = "github:hercules-ci/flake-parts";
  imp.url = "github:imp-nix/imp.lib";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Optional: visualization support (enables apps.visualize, apps.imp-vis)
  imp-graph.url = "github:imp-nix/imp.graph";
}
