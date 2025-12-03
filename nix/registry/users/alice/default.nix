{
  registry,
  imp,
  ...
}:
{
  imports = imp.imports [
    # DevShell combines shell + devTools with dev-specific additions
    registry.modules.home.features.devShell
    # Other standalone features
    registry.modules.home.features.modernUnix
    registry.modules.home.features.sync
  ];

  # User-specific git config (overrides devTools defaults)
  programs.git.settings.user = {
    name = "Alice";
    email = "alice@example.com";
  };

  home = {
    username = "alice";
    homeDirectory = "/home/alice";
    stateVersion = "24.05";
  };

  xdg.enable = true;
}
