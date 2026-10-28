
{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "ai";

      runtimeInputs = with pkgs; [
        curl
        jq
        wakeonlan
        coreutils
      ];

      text = ''
        url="http://192.168.1.32:11434"

        if [ "$#" -eq 0 ]; then
          echo "Usage: ai <prompt>"
          exit 1
        fi

        # Wake gaming PC if Ollama is unavailable
        if ! curl -fsS --max-time 2 "$url/api/tags" >/dev/null 2>&1; then
          echo "Waking gaming PC..."
          wakeonlan -i 192.168.1.32 f0:b6:1e:7f:ce:a7
        fi

        # Wait up to 2 minutes for the PC and Ollama
        for ((i=0; i<60; i++)); do
          if curl -fsS --max-time 2 "$url/api/tags" >/dev/null 2>&1; then
            break
          fi
          sleep 2
        done

        if ! curl -fsS --max-time 3 "$url/api/tags" >/dev/null; then
          echo "Ollama unavailable" >&2
          exit 1
        fi

        # Send prompt to GPU
        jq -n --arg prompt "$*" \
          '{model:"qwen3:8b",prompt:$prompt,stream:false,think:false}' |
          curl -fsS --max-time 300 \
            -H "Content-Type: application/json" \
            --data-binary @- "$url/api/generate" |
          jq -r '.response'
      '';
    })
  ];
}

