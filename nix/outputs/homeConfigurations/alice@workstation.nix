# Standalone Home Manager configuration for alice@workstation
{
  inputs,
  imp,
  nixpkgs,
  registry,
  ...
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  extraSpecialArgs = { inherit inputs imp registry; };
  modules = imp.import [ registry.users.alice ];
}
