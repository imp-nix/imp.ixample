# Desktop profile - Gaming support
{ pkgs, ... }:
{
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Gamemode for performance
  programs.gamemode.enable = true;

  # 32-bit libraries for games
  hardware.graphics.enable32Bit = true;
}
