# Desktop profile - Common desktop applications
{ pkgs, ... }:
{
  # Flatpak support
  services.flatpak.enable = true;

  # Desktop fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
    fontconfig.defaultFonts = {
      monospace = [ "FiraCode Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  # Printing
  services.printing.enable = true;
}
