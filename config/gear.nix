{ config, pkgs, ... }:

let
  gearDir = "/var/www/gear.thomascreagh.com";
  pythonEnv = pkgs.python312.withPackages (ps: with ps; [
    fastapi
    uvicorn
    sqlalchemy
    psycopg2
    python-jose
    passlib
    bcrypt
    pydantic
    email-validator 
    python-dotenv
    python-multipart
    cryptography
    openpyxl
    pandas
  ]);
in {
  # Systemd service for the FastAPI backend
  systemd.services.gear = {
    description = "Gear Renting API";
    after = [ "network.target" "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      DATABASE_URL = "postgresql://gearuser:gearpass@localhost/gear";
      SECRET_KEY_PATH = config.age.secrets.gear-secret-key.path;
      SMTP_HOST = "mail.0x74.net";
      SMTP_PORT = "587";
      SMTP_USER = "gear@thomascreagh.com";
      SMTP_PASS_PATH = config.age.secrets.gear-smtp-pass.path;
      ADMIN_EMAIL = "gear-admin@thomascreagh.com";
      MAX_LOAN_DAYS = "14";
      UPLOAD_DIR = "/var/lib/gear/uploads";
    };
    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/uvicorn main:app --host 0.0.0.0 --port 8001";
      WorkingDirectory = "${gearDir}/backend";
      Restart = "always";
      User = "tom";
      StateDirectory = "gear";
    };
  };

  # PostgreSQL DB
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "gear" ];
  };
  age.secrets.gear-secret-key = {
    file = ../secrets/gear-secret-key.age;
    owner = "tom";
    mode = "0400";
  };
  age.secrets.gear-smtp-pass = {
    file = ../secrets/gear-smtp-pass.age;
    owner = "tom";
    mode = "0400";
  };
}
