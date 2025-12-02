# Per-system dev shells
# Each file is a function receiving { self, pkgs, inputs }
{ pkgs, ... }:
{
  default = pkgs.mkShell {
    name = "ix-dev";

    packages = with pkgs; [
      # Nix tools
      nil
      nixfmt-rfc-style
      nix-tree
      nix-diff

      # General
      git
      jq
    ];

    shellHook = ''
      echo "IX development environment"
      echo "Available commands:"
      echo "  nix flake check    - Run all checks"
      echo "  nix build .#...    - Build an output"
      echo ""
    '';
  };

  # Minimal shell for CI
  ci = pkgs.mkShell {
    packages = with pkgs; [
      nix
      git
    ];
  };
}
