{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "h-server";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # server update settings
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # garbage collect
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";

  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_IE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # mount external disk
  fileSystems."/srv/storage" = {
    device = "/dev/disk/by-uuid/d0547a8d-6380-4011-b0ed-deec77d7e116";
    fsType = "ext4";
    options = [ "nofail" "defaults" ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ie";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "ie";

  # laptop server lid
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  users.users.tom = {
    isNormalUser = true;
    description = "tom";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim
    git
    parted
    usbutils
    wget
    sqlite
    wireguard-tools
    iproute2
    bind
    gawk
    p7zip
    unzip
    tcpdump
    nmap
    smartmontools
    traceroute
    conntrack-tools
    openssl
    jq
    apacheHttpd
  ];

  programs.nix-ld.enable = true;

  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
  };
  users.users.tom.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENbTFvT06FmDkvIoYiBsI7nD5fvDIIGD+Zkug55k6Hu 1mn8wx5y@3rktz5yu0ubrq9b6.org"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPkcGvfDHCD404iViEoKzY9WwxgN2Q+cMZ1g49O1Q7h 1mn8wx5y@3rktz5yu0ubrq9b6.org"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQ5HmVZ9WyUIbC2+syzTzYLB4848YUAkFl8H1h1s67G pc - home"
  ];

  system.stateVersion = "25.05";
}
