#!/bin/ash

set -e

# Check we have all required environment variables
if [ \
    -n "${TUNNEL_LOCAL}" \
    -a -n "${TUNNEL_REMOTE}" \
    -a -n "${PRIVKEY}" \
    -a -n "${REMOTE_PUBKEY}" \
    -a -n "${REMOTE_NETWORK}" \
]
then
    echo "[wireguard] Pre-flight checks: All present and correct"
else
    echo "[wireguard] Pre-flight checks: Missing environment variables - cannot proceed" >2
    exit 255
fi

echo "Building config"
cat >/etc/wireguard/wg0.conf <<EOF
[Interface]
Address = ${TUNNEL_LOCAL}/31
PrivateKey = ${PRIVKEY}
ListenPort = 52100 # mapped using docker-compose.yml
PostUp = /wireguard-post-updown.sh -A
PostDown = /wireguard-post-updown.sh -D

[Peer]
# vboxnet5
PublicKey = ${REMOTE_PUBKEY}
AllowedIPs = ${TUNNEL_REMOTE}/32,${REMOTE_NETWORK}
EOF

echo "$(date): Starting Wireguard"
wg-quick up wg0

# Handle shutdown behavior
finish () {
    echo "$(date): Shutting down Wireguard"
    wg-quick down wg0
    exit 0
}

trap finish SIGTERM SIGINT SIGQUIT

exec ip monitor address
