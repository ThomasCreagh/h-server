{
  description = "h-server configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix, ... }: {
    nixosConfigurations.h-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./config/system.nix
        ./config/hardware.nix
        ./config/immich.nix
        ./config/jellyfin.nix
        ./config/monitor.nix
        ./config/networking.nix
        ./config/radicale.nix
        ./config/terraria.nix
        ./config/vaultwarden.nix
        agenix.nixosModules.default
      ];
    };

    packages.x86_64-linux.agenix = agenix.packages.x86_64-linux.default;
  };
}
