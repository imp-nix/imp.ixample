{
  lib,
  flake-utils,
  pkgsFor,
  ...
}:
lib.genAttrs flake-utils.lib.defaultSystems (
  system:
  let
    pkgs = pkgsFor system;
  in
  {
    default = pkgs.mkShell {
      name = "ix-dev";
      packages = with pkgs; [
        nil
        nixfmt-rfc-style
        nix-tree
        nix-diff
        git
        jq
      ];
    };

    ci = pkgs.mkShell {
      packages = with pkgs; [
        nix
        git
      ];
    };
  }
)
