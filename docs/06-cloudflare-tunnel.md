# 6. Cloudflare Tunnel (HTTPS without opening ports)

Cloudflare terminates HTTPS, so you do **not** need Let's Encrypt on the server.

## Create the tunnel

1. Go to https://one.dash.cloudflare.com, Networks, Tunnels, **Create a tunnel**, Cloudflared.
2. Name it, choose **Debian / 64-bit**, copy the install commands, run them in the VM.
3. Wait until the connector shows **Connected**.

> The command contains a secret token. Never paste it into chat or commit it.

## Add the route

In the tunnel, add a route of type **Published application**:

| Field | Value |
|---|---|
| Subdomain | `helpdesk` |
| Domain | `example.com` |
| Path | empty |
| Service URL | `http://localhost:80` |

The newer dashboard has no separate "Type" field. The type is the `http://` prefix. Use `http`, not `https`, because nginx in the VM listens on plain HTTP.

If saving fails with a DNS conflict, delete the old `helpdesk` record under DNS, Records, and save again.

If you get "Site not found" / 404, set **HTTP Host Header** to `helpdesk.example.com` in the route's additional settings.

## Verify

```bash
sudo systemctl status cloudflared --no-pager | head -5
```

Open `https://helpdesk.example.com`, log in as `Administrator`. Helpdesk is at `/helpdesk`.

## Run the tunnel on only one machine

Never run the same tunnel connector on two servers at once. Traffic would split between servers with different data.
