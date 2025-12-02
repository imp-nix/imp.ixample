# users/users.nix -> users.users
{ ... }:
{
  alice = {
    isNormalUser = true;
    description = "Alice";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
