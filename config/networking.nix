{ config, pkgs, lib, ... }:

{
  age.secrets.wireguard = {
    file = ../secrets/wireguard.age;
    owner = "root";
    mode = "0400";
  };

  services.resolved.enable = false;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = "1";
    "net.ipv6.conf.all.forwarding" = "1";
  };

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    
    allowedTCPPorts = [
      22    # SSH (remote access)
      7777  # Terraria server (fun game :))
      80    # HTTP (web apps)
      443   # HTTPS (web apps)
      8222  # Vaultwarden (passwords)
      2283  # Immich (img server)
      5232  # Radicale (calendar and contacts)
      3000  # Grafana (server monitoring)
    ];
    allowedUDPPorts = [ 51820 ];
    
    trustedInterfaces = [ "wg0" ];
  };
  networking.useNetworkd = true;
  systemd.services."systemd-networkd-wait-online".enable = lib.mkForce false;
  
  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "fd31:bf08:57cb::7/64" "192.168.26.7/24" ];
      linkConfig.MTUBytes = 1420; # to accomidate for added vpn header
      routingPolicyRules = [
        { To = "91.98.237.217/32"; Priority = 5; }      # VPS endpoint: always use main table
        { To = "192.168.1.0/24"; Priority = 5; }        # local network: always use main table
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
        PrivateKeyFile = "%{file:${config.age.secrets.wireguard.path}}%";
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
  };
}
