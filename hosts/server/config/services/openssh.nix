# SSH server configuration
{ ... }:
{
  enable = true;
  settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
  };
}
