FROM alpine

LABEL maintainer="Matthew Slowe <matthew.slowe@jisc.ac.uk>"

RUN set -x && \
    apk update && \
    apk add wireguard-tools bind-tools syslinux nagios-plugins-ping

COPY start-wireguard.sh /
RUN chmod +x /start-wireguard.sh

ENTRYPOINT ["/start-wireguard.sh"]

# HEALTHCHECK --interval=60s --timeout=5s --start-period=120s \
#   CMD /bin/ping -qc 1 ${WG_TUNNEL_REMOTE}
