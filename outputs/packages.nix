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
    hello-ix = pkgs.writeShellScriptBin "hello-ix" ''
      echo "Hello from ix configuration!"
      echo "Built with Nix ${pkgs.lib.version}"
    '';

    docs = pkgs.runCommand "ix-docs" { } ''
      mkdir -p $out
      echo "# IX Configuration" > $out/index.html
      echo "<p>NixOS + Home Manager with imp</p>" >> $out/index.html
    '';
  }
)
