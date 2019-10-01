#!/bin/ash

set -e
MODE=${1:?Need mode}
IP_WIREGUARD=$(ip address show dev wg0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f 1)

# Port forward SSH to remote VPN node
iptables -t nat $MODE PREROUTING -p tcp -m tcp --dport 2222 -j DNAT --to-destination ${WG_TUNNEL_REMOTE}:22

# port forward :389 -> hidden_service:389
IP_SERVICE=$(gethostip -d hidden_service)
iptables -t nat $MODE PREROUTING -p tcp -m tcp --dport 389 -j DNAT --to-destination ${IP_SERVICE}:389

# iptables -t nat $MODE POSTROUTING -d ${IP_SERVICE} -o eth0 -p udp -j SNAT --to-source ${IP_WIREGUARD}
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
