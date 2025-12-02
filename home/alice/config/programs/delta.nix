# Delta (git pager) configuration
# Path: programs/delta.nix -> programs.delta = { ... }
{ ... }:
{
  enable = true;
  enableGitIntegration = true;
  options = {
    navigate = true;
    line-numbers = true;
    syntax-theme = "Dracula";
  };
}
