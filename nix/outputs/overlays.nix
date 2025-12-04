# Overlays exported by this flake
{ self, ... }:
{
  default = final: prev: {
    ixample = self.packages.${prev.system} or { };
  };
}
