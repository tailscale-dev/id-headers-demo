# Tailscale identity headers demo

This repository is a companion to the Tailscale blog post “Tapping into Tailscale’s identity headers with serve.” For more background, read that post, and then come back here to look under the hood. You can see the live demo at [https://id-headers-demo.pango-lin.ts.net](https://id-headers-demo.pango-lin.ts.net).

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

The listener program will look for two environment variables when it runs, but will operate fine without them. If you want to set those variables:

`DEMO_INVITE_LINK` is an invite link URL you can generate from your Tailscale admin console
`TAILSCALE_URL` is the URL on which the demo is available. We only use it to populate the URL in the social cards of our live demo.
