{ config, pkgs, lib, ... }:

{
  services.vaultwarden = {
    enable = true;
    config = {
      SIGNUPS_ALLOWED = true;
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
    };
    backupDir = "/srv/storage/backup/vaultwarden";
  };
}
