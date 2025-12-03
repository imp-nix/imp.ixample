# Developer Shell feature
# Combines shell + devTools, with developer-focused customizations
#
# This is a "mixed config tree" - it merges multiple feature trees:
#   - shell: zsh, starship, fzf, direnv
#   - devTools: git, delta, neovim
#   - ./: additional dev-specific overrides
#
# Uses "merge" strategy so shell aliases concatenate rather than replace
{ imp, registry, ... }:
{
  imports = [
    (imp.mergeConfigTrees { strategy = "merge"; } [
      registry.modules.home.features.shell
      registry.modules.home.features.devTools
      ./.
    ])
  ];
}
