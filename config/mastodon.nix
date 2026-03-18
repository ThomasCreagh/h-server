{ config, pkgs, lib, ... }:

{
  services.mastodon = {
    enable = true;
    enableUnixSocket = false;
    webPort = 55001;
    localDomain = "social.thomascreagh.com";
    configureNginx = false;
    smtp.fromAddress = "noreply@social.thomascreagh.com";
    trustedProxy = "192.168.26.1";
    extraConfig = {
      RAILS_SERVE_STATIC_FILES = "true";
      BIND = "0.0.0.0";
      # SINGLE_USER_MODE = "true";
    };
    streamingProcesses = 2;
    package = pkgs.mastodon.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [
        ../patches/mastodon-character-limit.patch
      ];
    });
  };
}
