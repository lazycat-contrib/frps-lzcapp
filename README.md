# frps LazyCat App

This directory packages `frps` `v0.70.1` as a LazyCat LPK v2 application using the official image `ghcr.io/fatedier/frps:v0.70.1`.

## What it exposes

- HTTP management UI through LazyCat at the application subdomain, backed by `host.lzcapp:7500`
- Host-network TCP port `7000` for the frp control channel
- Host-network TCP port `6000` as the only allowed proxy port

The service uses host networking. `/etc/frp` is backed by `/lzcapp/var/frps/config`. A packaged entrypoint script initializes `/etc/frp/frps.toml` only when that file does not exist, then executes `frps -c /etc/frp/frps.toml`. Restarts and upgrades preserve user changes. frp renders the initial template from `FRPS_*` environment variables.

## Deployment parameters

- `auth_token`: required secret shared by `frps` and every paired `frpc`
- `webserver_user`: dashboard username, default `admin`
- `webserver_password`: dashboard password, default random secret

## Pairing with frpc

1. Deploy this app and record the LazyCat public domain plus your `auth_token`.
2. In your `frpc.toml`, point `serverAddr` to the LazyCat domain of this app and `serverPort` to `7000`.
3. Set the same token under `auth.token`.
4. Expose only remote port `6000` in your `frpc` proxy definitions, because this package intentionally limits `allowPorts` to that single port.
5. Open the LazyCat app URL to reach the frps dashboard; LazyCat injects the required Basic Authorization header automatically.

Minimal example:

```toml
serverAddr = "your-frps-domain.example.com"
serverPort = 7000

auth.method = "token"
auth.token = "same-token-as-frps"

[[proxies]]
name = "demo"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 6000
```

## References

- https://gofrp.org/zh-cn/
- https://gofrp.org/zh-cn/docs/features/common/ui
- https://github.com/fatedier/frp
