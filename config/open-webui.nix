{ config, pkgs, ... }:

{
  services.open-webui = {
    enable = true;

    # Only accessible through SSH tunnelling
    host = "127.0.0.1";
    port = 8080;

    # Ollama on the gaming PC
    environment = {
      OLLAMA_BASE_URL = "http://192.168.1.32:11434";
    };
  };
}

