{ ... }:
{
  alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "changeme";
  };
  root.initialPassword = "changeme";
}
