{ config, pkgs, lib, ... }:

{
  systemd.services.terraria = {
    description = "Terraria Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash /home/tom/terraria-server/start-terraria.sh";
      Restart = "always";
      User = "tom";
      WorkingDirectory = "/home/tom/terraria-server";
    };
  };
}
