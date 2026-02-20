let
  hServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFtBRaCtsG4sK6yJN/PKFcABYVpQ0+zXWUSpbdK5XBhq root@nixos";
in {
  "secrets/wireguard.age".publicKeys = [ hServer ];
  "secrets/radicale.age".publicKeys = [ hServer ];
}
