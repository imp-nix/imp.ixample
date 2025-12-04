# Custom packages
{ pkgs, ... }:
{
  hello-ixample = pkgs.writeShellScriptBin "hello-ixample" ''
    echo "Hello from Ixample configuration!"
    echo "Built with Nix ${pkgs.lib.version}"
  '';

  docs = pkgs.runCommand "ixample-docs" { } ''
    mkdir -p $out
    echo "# Ixample Configuration" > $out/index.html
    echo "<p>NixOS + Home Manager with imp</p>" >> $out/index.html
  '';
}
