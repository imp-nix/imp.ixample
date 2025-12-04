# Nested packages example
# This demonstrates how imp.treeWith creates nested attrs:
#   outputs/packages/scripts.nix -> packages.scripts.{ ... }
{ pkgs, ... }:
{
  backup = pkgs.writeShellScriptBin "ixample-backup" ''
    echo "Backing up configuration..."
    ${pkgs.rsync}/bin/rsync -av --exclude='.git' . ~/backups/ixample-$(date +%Y%m%d)/
  '';

  clean = pkgs.writeShellScriptBin "ixample-clean" ''
    echo "Cleaning old generations..."
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
  '';
}
