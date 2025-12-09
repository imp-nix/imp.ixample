/**
  Desktop environment feature.

  Bundles fonts, flatpak, and printing for a complete desktop experience.
  Exports to `nixos.role.desktop` for aggregation-based consumption.
*/
let
  desktopModule =
    { pkgs, ... }:
    {
      services.flatpak.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*";
      };

      fonts = {
        packages = with pkgs; [
          noto-fonts
          noto-fonts-color-emoji
          fira-code
          fira-code-symbols
          nerd-fonts.fira-code
        ];
        fontconfig.defaultFonts = {
          monospace = [ "FiraCode Nerd Font" ];
          sansSerif = [ "Noto Sans" ];
          serif = [ "Noto Serif" ];
        };
      };

      services.printing.enable = true;
    };
in
{
  __exports."nixos.role.desktop" = {
    value = desktopModule;
    strategy = "mkMerge";
  };

  __functor = _: desktopModule;
}
