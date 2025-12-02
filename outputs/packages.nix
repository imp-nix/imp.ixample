# Per-system packages
# Loaded via imp.treeWith: each file receives { self, pkgs, inputs }
{ pkgs, ... }:
{
  # A custom script package
  hello-ix = pkgs.writeShellScriptBin "hello-ix" ''
    echo "Hello from ix configuration!"
    echo "Built with Nix ${pkgs.lib.version}"
  '';

  # Documentation
  docs = pkgs.runCommand "ix-docs" { } ''
    mkdir -p $out
    echo "# IX Configuration" > $out/index.html
    echo "<p>NixOS + Home Manager with imp</p>" >> $out/index.html
  '';
}
