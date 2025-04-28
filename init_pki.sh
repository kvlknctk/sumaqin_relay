#!/bin/bash
set -e

cd /etc/openvpn
cp -r /usr/share/easy-rsa /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa

# Create PKI structure
export EASYRSA_BATCH=1
export EASYRSA_REQ_CN="OpenVPN-CA"
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa build-server-full server nopass
./easyrsa build-client-full client-windows nopass
./easyrsa build-client-full client-orangepi nopass
./easyrsa gen-dh
openvpn --genkey --secret /etc/openvpn/easy-rsa/pki/ta.key

# Copy certificates to the correct location expected by server.conf
mkdir -p /etc/openvpn/pki/issued /etc/openvpn/pki/private
cp /etc/openvpn/easy-rsa/pki/ca.crt /etc/openvpn/pki/
cp /etc/openvpn/easy-rsa/pki/issued/server.crt /etc/openvpn/pki/issued/
cp /etc/openvpn/easy-rsa/pki/private/server.key /etc/openvpn/pki/private/
cp /etc/openvpn/easy-rsa/pki/dh.pem /etc/openvpn/pki/
cp /etc/openvpn/easy-rsa/pki/ta.key /etc/openvpn/pki/