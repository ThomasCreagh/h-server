{ config, pkgs, lib, ... }:

let
  domain = "0x74.net";
  matrixDomain = "matrix.${domain}";
in {
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = domain;
      public.baseurl = "https://${matrixDomain}";
   
 
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "0.0.0.0" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = true;
            }
          ];
        }
      ];
      
      database = {
        name = "psycopg2";
        allow_unsafe_locale = true;
        args = {
          user = "matrix-synapse";
          database = "matrix-synapse";
          host = "/run/postgresql";
        };
      };
      
      max_upload_size_mib = 100;
      url_preview_enabled = true;
      enable_registration = false;
      enable_metrics = false;
      registration_shared_secret_path = "/var/lib/matrix-sytnapse/registration_secret";
      trusted_key_servers = [
        {
          server_name = "matrix.org";
        }
      ];

      #federation_domain_whitelist = [];
      #allow_public_rooms_over_federation = false;
      #allow_public_rooms_without_auth = false;
      #federation_sender_instances = [];
    };
  };
  
  services.postgresql = {
    enable = true;
    ensureDatabases = ["matrix-synapse"];
    ensureUsers = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
      }
    ];
  };
}
