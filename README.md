# Tailscale identity headers demo

This repository is a companion to the Tailscale blog post “[Tapping into Tailscale’s identity headers with Serve](https://tailscale.dev/blog/id-headers-tailscale-serve-flask).” For more background, read that post, and then come back here to look under the hood. You can see the live demo at [https://id-headers-demo.pango-lin.ts.net](https://id-headers-demo.pango-lin.ts.net).

Note that these identity headers are tied to the underlying Tailscale connection, and so they work a little differently from a cookie-based authentication model. For example, the same headers will be sent when accessing the service within private browsing sessions, from different browsers, or even on the same user's other devices on the tailnet.

For the purpose of this demo, we’re keeping things simple and the entire Flask app is one function in a file.

If you want to run your own copy, we recommend starting by cloning this repo and then creating a new virtual environment in its directory and installing Flask.

```
$ git clone git@github.com:tailscale-dev/id-headers-demo.git
$ cd id-headers-demo
$ python -m venv .venv
$ source .venv/bin/activate
$ python -m pip install flask
```

Then run the Flask app from the command line. Use `serve` to make it visible to your tailnet, and (optionally) Tailscale Funnel to open it to the world.

```
$ python listener.py &
$ tailscale serve https / 127.0.0.1:5000
$ tailscale funnel 443 on
```

The Flask server is fine for development, but not advised for production deployment. Our instance of this demo is behind [`gunicorn`](https://gunicorn.org/), but otherwise exactly as described here.

The listener program will look for two environment variables when it runs, but will operate fine without them. If you want to set those variables:

- `DEMO_INVITE_LINK` is an invite link URL you can generate from your Tailscale admin console
- `TAILSCALE_URL` is the URL on which the demo is available. We only use it to populate the URL in the social cards of our live demo.

## docker

Recently we added docker support to this image. It can now be deployed using a Linuxserver.io image and their "docker mod" concept which lets you install software at run time - in our case we install Tailscale into the container so that we can run one instance of this demo per event we attend from a single VPS VM.

More details available in the devrel [infra repo](https://github.com/tailscale-dev/devrel-demo-infra). But an example compose snippet might look like this once you've built the app with `docker build -t <image>:<tag> .`:

```
---
version: "2"
services:
  id-demo-cleveland:
    image: ghcr.io/tailscale-dev/demo-id-headers:cleveland
    container_name: id-demo-cleveland
    volumes:
      - /mnt/zfs/appdata/2023/cleveland:/var/lib/tailscale
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - DOCKER_MODS=ghcr.io/tailscale-dev/docker-mod:main
      - TAILSCALE_STATE_DIR=/var/lib/tailscale
      - TAILSCALE_SERVE_MODE=https
      - TAILSCALE_SERVE_PORT=5000
      - TAILSCALE_USE_SSH=0
      - TAILSCALE_AUTHKEY=tskey-auth-1234
      - TAILSCALE_HOSTNAME=hello-cleveland
      - TAILSCALE_FUNNEL=on
    restart: unless-stopped
```