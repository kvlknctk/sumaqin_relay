#!/bin/bash
set -e

# Execute init_pki.sh from the correct path
/usr/local/bin/init_pki.sh

OVPN_CONF="/etc/openvpn/server.conf"
PORT=${OVPN_PORT:-1194}
PROTO=${OVPN_PROTO:-udp}
CID=$((PORT - 1193)) # örn: 1194 -> 1, 1195 -> 2
DEV="tap0"
CERT_DIR="/etc/openvpn/easy-rsa/pki"

# Ensure the TAP interface exists
if ! ip link show tap0 &>/dev/null; then
  echo "Creating TAP interface tap0"
  ip tuntap add dev tap0 mode tap
  ip link set tap0 up
fi

# Create bridge if it doesn't exist
if ! ip link show br0 &>/dev/null; then
  echo "Creating bridge interface br0"
  brctl addbr br0
  brctl addif br0 tap0  # Add TAP interface to bridge
  ip addr add 10.8.$CID.1/24 dev br0  # Add IP to bridge
  ip link set br0 up
fi

# Generate server configuration
if [ ! -f "$OVPN_CONF" ]; then
  sed -e "s/{{PORT}}/$PORT/g" \
      -e "s/{{PROTO}}/$PROTO/g" \
      -e "s/{{CID}}/$CID/g" \
      /etc/openvpn/server.conf.template > $OVPN_CONF
fi

COMMON_CFG=$(cat /etc/openvpn/client-common.txt)
COMMON_CFG=${COMMON_CFG//\{\{PORT\}\}/$PORT}

# client-windows.ovpn
cat > /etc/openvpn/export/client-windows.ovpn <<EOF
$COMMON_CFG
dev tap
key-direction 1
<ca>
$(cat $CERT_DIR/ca.crt)
</ca>
<cert>
$(cat $CERT_DIR/issued/client-windows.crt)
</cert>
<key>
$(cat $CERT_DIR/private/client-windows.key)
</key>
<tls-auth>
$(cat $CERT_DIR/ta.key)
</tls-auth>
EOF

# client-orangepi.ovpn
cat > /etc/openvpn/export/client-orangepi.ovpn <<EOF
$COMMON_CFG
dev tap
key-direction 1
<ca>
$(cat $CERT_DIR/ca.crt)
</ca>
<cert>
$(cat $CERT_DIR/issued/client-orangepi.crt)
</cert>
<key>
$(cat $CERT_DIR/private/client-orangepi.key)
</key>
<tls-auth>
$(cat $CERT_DIR/ta.key)
</tls-auth>
EOF

exec "$@"
