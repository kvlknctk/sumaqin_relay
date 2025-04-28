# sumaqin_relay

For relay server docker 

````
docker run -v $OVPN_DATA:/etc/openvpn --rm salvoxia/openvpn-tap ovpn_genconfig -u udp://SUNUCU_IP_ADRESINIZ:1194 -t -B --bridge-name 'br0' --bridge-eth-if 'eth0' --bridge-eth-ip '192.168.0.199' --bridge-eth-subnet '255.255.255.0' --bridge-eth-gateway '192.168.0.1' --bridge-eth-mac 'xx:xx:xx:xx:xx:xx' --bridge-dhcp-start '192.168.0.200' --bridge-dhcp-end '192.168.0.220'
````

````
docker run -v $OVPN_DATA:/etc/openvpn --rm -it salvoxia/openvpn-tap easyrsa build-client-full orange_pi nopass
docker run -v $OVPN_DATA:/etc/openvpn --rm -it salvoxia/openvpn-tap easyrsa build-client-full windows_client nopass
````

````
docker run -v $OVPN_DATA:/etc/openvpn --rm salvoxia/openvpn-tap ovpn_getclient orange_pi > orange_pi.ovpn
docker run -v $OVPN_DATA:/etc/openvpn --rm salvoxia/openvpn-tap ovpn_getclient windows_client > windows_client.ovpn
````
