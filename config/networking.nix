{ config, pkgs, lib, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@0x74.net";
  };

  age.secrets.wireguard = {
    file = ../secrets/wireguard.age;
    owner = "systemd-network";
    mode = "0400";
  };

  networking.networkmanager.enable = false;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = "1";
    "net.ipv6.conf.all.forwarding" = "1";
  };

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    allowedTCPPorts = [ 22 ]; # SSH (remote access)
    trustedInterfaces = [ "wg0" ]; # allow all ports over this interface
  };
  networking.useNetworkd = true;
  systemd.services."systemd-networkd-wait-online".enable = lib.mkForce false;
  
  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "fd31:bf08:57cb::7/64" "192.168.26.7/24" ];
      networkConfig = {
        DNS="192.168.26.1";
        Domains="~.";
      };
      routingPolicyRules = [
        { To = "91.98.237.217/32"; Priority = 5; }      # VPS endpoint: always use main table
        { To = "192.168.1.0/24"; Priority = 5; }        # local network: always use main table
        { To = "nixos.org"; Priority = 5; }             # nixos.org: always use main table
        { 
          # Default route for all traffic
          Family = "both";
          InvertRule = true;
          FirewallMark = 42;
          Table = 1000;
          Priority = 200;
        }
      ];
      routes = [
        { Destination = "0.0.0.0/0"; Table = 1000; }
        { Destination = "::/0"; Table = 1000; }
      ];
    };
  
    netdevs."50-wg0" = {
      netdevConfig = { Kind = "wireguard"; Name = "wg0"; };
      wireguardConfig = {
        PrivateKeyFile = config.age.secrets.wireguard.path;
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          PublicKey = "SiK03VH5ayt0NRwAzf9O3IoxbE05Qh0LfT6G6vnBeGw=";
          AllowedIPs = [ "0.0.0.0/0" "::/0" ];
          Endpoint = "91.98.237.217:51820";
          RouteTable = 1000;
          PersistentKeepalive = 25;
        }
      ];
    };
    networks."10-eth" = {
      matchConfig.Name = "enp0s20f0u2";
      networkConfig.DHCP = "yes";
      dhcpV4Config.RouteMetric = 100;
    };
  };
}
