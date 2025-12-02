# Security hardening module
{ lib, ... }:
{
  # Kernel hardening
  boot.kernel.sysctl = {
    "kernel.dmesg_restrict" = true;
    "kernel.kptr_restrict" = 2;
    "net.core.bpf_jit_enable" = false;
    "kernel.unprivileged_bpf_disabled" = true;
  };

  # Limit sudo timeout
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=15
  '';

  # Enable audit
  security.auditd.enable = lib.mkDefault true;

  # Fail2ban for SSH protection
  services.fail2ban = {
    enable = true;
    maxretry = 5;
  };
}
