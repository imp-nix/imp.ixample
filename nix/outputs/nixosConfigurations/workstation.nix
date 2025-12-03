# Workstation NixOS configuration
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
    registry.hosts.workstation
    registry.modules.nixos.base
    registry.modules.nixos.features.desktop
    registry.modules.nixos.features.gaming
    registry.modules.nixos.features.hardening
  ];
}
