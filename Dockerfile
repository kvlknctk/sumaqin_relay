FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openvpn easy-rsa iproute2 iputils-ping net-tools bridge-utils && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/openvpn/pki
COPY init_pki.sh /usr/local/bin/init_pki.sh
RUN chmod +x /usr/local/bin/init_pki.sh

COPY server.conf.template /etc/openvpn/server.conf.template
COPY client-common.txt /etc/openvpn/client-common.txt

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /etc/openvpn/export

ENV OVPN_PORT=1194
ENV OVPN_PROTO=udp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["openvpn", "--config", "/etc/openvpn/server.conf"]
