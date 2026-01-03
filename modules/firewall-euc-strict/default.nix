{ config, lib, pkgs, ... }:

{
  networking.nftables.enable = true;
  networking.enableIPv6 = false;

  networking.firewall = {
    enable = true;
    rejectPackets = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    filterForward = true;
    allowPing = false;
    logRefusedPackets  = false;
    logReversePathDrops = false;
  };

  # Kernel Hardening
  boot.kernel.sysctl = {
    # ICMP / Redirects
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    #"net.ipv6.conf.all.accept_redirects" = 0;
    #"net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;

    # Kernel sysctls stricter ARP behaviour
    "net.ipv4.conf.all.arp_ignore" = 1;
    "net.ipv4.conf.default.arp_ignore" = 1;
    "net.ipv4.conf.all.arp_announce" = 2;
    "net.ipv4.conf.default.arp_announce" = 2;

    # Reverse Path Filtering
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;

    # ICMP Hardening
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.icmp_echo_ignore_all" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # TCP Hardening
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_timestamps" = 0;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.tcp_max_syn_backlog" = 2048;

    # Source-routing and martians
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;

    # Prevents localhost sourced packets on non-loopback interfaces
    "net.ipv4.conf.all.accept_local" = 0;

    # Prevent ptrace from non-root
    "kernel.yama.ptrace_scope" = 1;
  };

  networking.networkmanager = {
    wifi = {
      macAddress = "random";
    };
  };
}