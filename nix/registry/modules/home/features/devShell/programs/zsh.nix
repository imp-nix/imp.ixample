# DevShell feature - additional zsh config for developers
# These additions merge with shell's base zsh config
{ lib, ... }:
{
  # Extra aliases for dev workflow (merged with shell's aliases)
  shellAliases = {
    # Docker
    d = "docker";
    dc = "docker compose";
    dps = "docker ps";

    # Nix development
    nb = "nix build";
    nd = "nix develop";
    nf = "nix flake";
    nr = "nix run";
  };

  # Additional shell init (concatenated with shell's initContent)
  initContent = lib.mkAfter ''
    # Dev environment helpers
    export EDITOR="nvim"
    export VISUAL="nvim"

    # Load project-local .envrc automatically
    eval "$(direnv hook zsh)"
  '';
}
