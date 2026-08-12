#!/bin/sh
set -eu

if [ ! -f /etc/frp/frps.toml ]; then
  cp /lzcapp/pkg/content/frps.toml /etc/frp/frps.toml
fi

exec /usr/bin/frps -c /etc/frp/frps.toml
