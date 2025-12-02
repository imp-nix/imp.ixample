# services/pipewire.nix -> services.pipewire
{ ... }:
{
  enable = true;
  alsa.enable = true;
  pulse.enable = true;
}
