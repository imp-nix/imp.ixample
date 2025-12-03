# Run with: nix run .#vm
{
  imp,
  inputs,
  registry,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
    (imp.configTree ./config)
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs imp registry; };
    users.alice = import registry.users.alice;
  };

  virtualisation = {
    memorySize = 4096;
    cores = 2;
    graphics = true;
    qemu.options = [
      "-vga virtio"
      "-display gtk,zoom-to-fit=on"
    ];
    forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
    ];
    sharedDirectories = {
      config = {
        source = "$HOME/flakes/ix";
        target = "/mnt/config";
      };
    };
  };

  environment.etc."motd".text = ''

    ╔═══════════════════════════════════════════════════════════╗
    ║  IX NixOS Test VM                                         ║
    ║                                                           ║
    ║  User: alice (password: changeme)                         ║
    ║  Root password: changeme                                  ║
    ║  SSH: ssh -p 2222 alice@localhost                         ║
    ║  Config mounted at: /mnt/config                           ║
    ║                                                           ║
    ║  Rebuild: sudo nixos-rebuild test --flake /mnt/config     ║
    ╚═══════════════════════════════════════════════════════════╝

  '';

  system.stateVersion = "24.05";
}
