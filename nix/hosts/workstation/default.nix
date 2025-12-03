{
  imp,
  inputs,
  registry,
  modulesPath,
  ...
}:
{
  imports = [
    ./hardware.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (imp.configTree ./config)
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs imp registry; };
    users.alice = import registry.users.alice;
  };

  system.stateVersion = "24.05";
}
