{ config, pkgs, lib, ... }:

{
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "0x74.net";
   
      federation_domain_whitelist = [];
      allow_public_rooms_over_federation = false;
      allow_public_rooms_without_auth = false;
      federation_sender_instances = [];

      enable_registration = false;
  
      listeners = [{
        port = 8008;
        bind_addresses = [ "0.0.0.0" ];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = true;
        }];
      }];
    };
  };
}
