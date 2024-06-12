version: "3.7"

services:
  ts-op-connect:
    image: tailscale/tailscale:latest
    container_name: ts-op-connect
    hostname: "op://Coto.Studio/Tailscale OAuth/hostname"
    networks:
      - op-connect
    environment:
      - TS_AUTHKEY="op://Coto.Studio/Tailscale OAuth/credential"
      - TS_EXTRA_ARGS=--advertise-tags=tag:container
      - TS_STATE_DIR=/var/lib/tailscale
    volumes:
      - tailscale:/var/lib/tailscale
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - net_admin
      - sys_module
    restart: unless-stopped

  op-connect-api:
    image: 1password/connect-api:latest
    volumes:
      - "./1password-credentials.json:/home/opuser/.op/1password-credentials.json"
      - "data:/home/opuser/.op/data"
    network_mode: service:ts-op-connect

  op-connect-sync:
    image: 1password/connect-sync:latest
    volumes:
      - "./1password-credentials.json:/home/opuser/.op/1password-credentials.json"
      - "data:/home/opuser/.op/data"
    networks:
      - op-connect

volumes:
  data:
  tailscale:

networks:
  op-connect:
