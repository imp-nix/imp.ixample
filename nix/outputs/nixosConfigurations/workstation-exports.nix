/**
  Workstation configuration using export sinks.

  Demonstrates the export pattern: instead of manually importing features,
  consume the aggregated `nixos.role.desktop` sink which merges all modules
  that declared `__exports."nixos.role.desktop"`.
*/
{
  lib,
  inputs,
  imp,
  registry,
  self,
  ...
}:
lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs imp registry; };
  modules = imp.imports [
    registry.hosts.workstation
    registry.modules.nixos.base
    registry.modules.nixos.features.hardening
    self.exports.nixos.role.desktop.__module
  ];
}
