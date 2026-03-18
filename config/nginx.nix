{ config, lib, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "social.thomascreagh.com" = {
        forceSSL = false;
        enableACME = false;
        locations."/" = {
          proxyPass = "http://127.0.0.1:55001";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
          '';
        };
        locations."/packs/" = {
          root = "${pkgs.mastodon}/public";
        };
        locations."/assets/" = {
          root = "${pkgs.mastodon}/public";
        };
        locations."/system/" = {
          root = "${pkgs.mastodon}/public";
        };
      };
    };
  };
}
