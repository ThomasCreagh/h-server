{ config, pkgs, lib, ... }:

{
  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = true;
    dataDir = "/srv/storage/jellyfin/data";
    configDir = "/srv/storage/jellyfin/config";
    cacheDir = "/srv/storage/jellyfin/cache";
  };
}
