/**
  Gaming feature.

  Steam, gamemode, and graphics support for gaming on NixOS.
  Exports to `nixos.role.desktop` for aggregation-based consumption.
*/
let
  gamingModule =
    { ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
      };

      programs.gamemode.enable = true;

      hardware.graphics.enable32Bit = true;
    };
in
{
  __exports."nixos.role.desktop" = {
    value = gamingModule;
    strategy = "mkMerge";
  };

  __functor = _: gamingModule;
}
