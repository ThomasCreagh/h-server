{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "gear" ];
    ensureUsers = [{
      name = "gearuser";
      ensureDBOwnership = false;
    }];
  };
}
