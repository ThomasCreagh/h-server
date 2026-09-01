let
  hServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFtBRaCtsG4sK6yJN/PKFcABYVpQ0+zXWUSpbdK5XBhq root@nixos";
in {
  "secrets/wireguard.age".publicKeys = [ hServer ];
  "secrets/radicale.age".publicKeys = [ hServer ];
  "secrets/grafana-admin-password.age".publicKeys = [ hServer ];
  "secrets/grafana-secret-key.age".publicKeys = [ hServer ];
  "secrets/coturn.age".publicKeys = [ hServer ];
  "secrets/gear-smtp-pass.age".publicKeys = [ hServer ];
  "secrets/gear-secret-key.age".publicKeys = [ hServer ];
}
