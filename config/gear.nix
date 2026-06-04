{ config, pkgs, ... }:

let
  gearDir = /var/www/gear.thomascreagh.com;
  pythonEnv = pkgs.python312.withPackages (ps: with ps; [
    fastapi uvicorn sqlalchemy psycopg2 python-jose passlib
    pydantic python-dotenv python-multipart
  ]);
in {
  # Systemd service for the FastAPI backend
  systemd.services.gear = {
    description = "Gear Renting API";
    after = [ "network.target" "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      DATABASE_URL = "postgresql://gearuser:gearpass@localhost/gear";
      SECRET_KEY = "$(cat /run/agenix/gear-secret-key)";
      SMTP_HOST = "mail.0x74.net";
      SMTP_PORT = "587";
      SMTP_USER = "gear@thomascreagh.com";
      ADMIN_EMAIL = "gear-admin@thomascreagh.com";
    };
    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/uvicorn main:app --host 0.0.0.0 --port 8001";
      WorkingDirectory = "${gearDir}/backend";
      Restart = "always";
      User = "tom";
    };
  };

  # PostgreSQL DB
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "gear" ];
  };
}
