{ config, pkgs, lib, ... }:

{
  services.mastodon = {
    enable = true;
    localDomain = "social.thomascreagh.net.com";
    configureNginx = true;
    smtp.fromAddress = "noreply@social.thomascreagh.com";
    extraConfig = {
      # SINGLE_USER_MODE = "true";
    };
    streamingProcesses = 2;
  };
}
