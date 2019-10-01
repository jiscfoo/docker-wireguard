Wireguard point-to-point endpoint within Docker
=====================

This Docker container is a starting point for building a Point-to-point (or star) wireguard arrangement.

You'll need to edit `wireguard-post-updown.sh` to suit your needs and link it into the container at runtime (or build time).

It requires the following environment settings:

* `TUNNEL_LOCAL` - the IP address for _this_ end of the VPN tunnel
* `TUNNEL_REMOTE` - the IP address for the _other_ end of the VPN tunnel
* `PRIVKEY` - the Wireguard private key for _this_ end of the VPN tunnel
* `REMOTE_PUBKEY` - the Wireguard public key for the (one) other end of the tunnel.
* `REMOTE_NETWORK` - the routes to publish for this tunnel (gets used in `AllowedIPs`)

Building
--------

Optionally prepare your `wireguard-post-updown.sh` and, if you want it burnt into the image, add it to the `COPY` and `RUN chmod` lines in the `Dockerfile`

```
docker build -t wgvpn .
```

Running
-------

Manually running from the command line might go something like:

```
docker run --cap-add net_admin --env-file vpn.env -p 51280:52100/udp -p 22001:2222 --rm -ti -v ${PWD}/wireguard-post-updown.sh:/wireguard-post-updown.sh:ro wgvpn
```

Example for docker-compose.yml:

```
  wgvpn:
    image: 'wireguard'
    ports:
      - '51280:52100/udp'
      - '22001:2222'
    cap_add:
      - NET_ADMIN
    environment:
      - TUNNEL_LOCAL=10.87.21.16
      - TUNNEL_REMOTE=10.87.21.17
      - PRIVKEY=mKYYqGY97ohtZKrdZngCoRzlBs59bJf5+xu698ohpG8=
      - REMOTE_PUBKEY=AtTvS+1kH1zEY3K0adHlPc6xv/dK6NQdj2M5iDrNP3Y=
      - REMOTE_NETWORK=172.20.12.128/25
```