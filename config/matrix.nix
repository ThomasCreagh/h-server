{
  config,
  pkgs,
  lib,
  ...
}: let
  domain = "0x74.net";
  matrixDomain = "matrix.${domain}";
  clientConfig = {
    "m.homeserver".base_url = "https://${matrixDomain}";
    "m.identity_server" = {};
  };
  serverConfig = {
    "m.server" = "${matrixDomain}:443";
  };
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
  #coturnSecret = builtins.readFile config.age.secrets.coturn.file;
in {
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = domain;
      public_baseurl = "https://${matrixDomain}";

      listeners = [
        {
          port = 8008;
          bind_addresses = ["0.0.0.0"];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = ["client" "federation"];
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
      registration_shared_secret_path = "/var/lib/matrix-synapse/registration_secret";

      trusted_key_servers = [
        {
          server_name = "matrix.org";
        }
      ];

      turn_uris = [
        "turn:turn.0x74.net:5349?transport=udp"
        "turn:turn.0x74.net:5350?transport=udp"
        "turn:turn.0x74.net:5349?transport=tcp"
        "turn:turn.0x74.net:5350?transport=tcp"
      ];
      #turn_shared_secret = coturnSecret;
    };

    extraConfigFiles = [
      config.age.secrets.coturn.path
    ];
  };

  services.lk-jwt-service = {
    enable = true;
    keyFile = config.age.secrets.lk-jwt.path;
    livekitUrl = "https://matrix-s9rky4oh.livekit.cloud";
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

  age.secrets.coturn = {
    file = ../secrets/coturn.age;
    owner = "matrix-synapse";
    mode = "0400";
  };
}
