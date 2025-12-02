# Shared Home Manager base module
{ pkgs, ... }:
{
  # Common development tools
  home.packages = with pkgs; [
    # Development
    gnumake
    gcc

    # Utils
    bat
    eza
    duf
  ];

  # Better ls
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  # Better cat
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "less -FR";
    };
  };
}
