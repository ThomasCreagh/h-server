
{ pkgs, ... }:

let
  weatherDir = "/var/www/weather.thomascreagh.com";
in {
  systemd.services.cragweather = {
    description = "CragWeather Web Application";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      PORT = "3001";
      NODE_ENV = "production";
    };

    serviceConfig = {
      ExecStart = "${pkgs.nodejs_22}/bin/node ${weatherDir}/server.js";
      WorkingDirectory = weatherDir;

      EnvironmentFile = "/var/lib/cragweather/.env";

      Restart = "always";
      RestartSec = 5;

      User = "tom";
    };
  };
}

