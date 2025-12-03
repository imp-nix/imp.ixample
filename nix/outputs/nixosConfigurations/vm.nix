# VM NixOS configuration - run with: nix run .#vm
{
  lib,
  inputs,
  imp,
  registry,
  ...
}:
lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs imp registry; };
  modules = imp.imports [
    registry.hosts.vm
    registry.modules.nixos.base
    registry.modules.nixos.features.desktop
  ];
}
