{
  self,
  lib,
  flake-utils,
  pkgsFor,
  treefmt-nix,
  ...
}:
lib.genAttrs flake-utils.lib.defaultSystems (
  system:
  let
    pkgs = pkgsFor system;
    treefmtEval = treefmt-nix.lib.evalModule pkgs {
      projectRootFile = "flake.nix";
      programs.nixfmt.enable = true;
    };
  in
  {
    formatting = treefmtEval.config.build.check self;
  }
)
