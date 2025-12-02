# Server profile - Nginx web server
# These modules are selectively imported using:
#   imp.filter (lib.hasInfix "/server/") ./modules/profiles
{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  # Open HTTP/HTTPS ports
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
