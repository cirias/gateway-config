#!/bin/bash
# Create new chain
iptables -t nat -N SHADOWSOCKS
iptables -t mangle -N SHADOWSOCKS
iptables -t mangle -N SHADOWSOCKS_MARK

# Ignore your shadowsocks server's addresses
# It's very IMPORTANT, just be careful.
iptables -t nat -A SHADOWSOCKS -d <server_address> -j RETURN

# Ignore LANs and any other addresses you'd like to bypass the proxy
# See Wikipedia and RFC5735 for full list of reserved networks.
# See ashi009/bestroutetb for a highly optimized CHN route list.
iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
# iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
# iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -m set --match-set ip_whitelist dst -j RETURN
iptables -t nat -A SHADOWSOCKS -m set --match-set ip_cn dst -j RETURN
iptables -t nat -A SHADOWSOCKS -m geoip --destination-country CN -j RETURN

# Anything else should be redirected to shadowsocks's local port
iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1080

# Add any rules for DNS
ip route add local default dev lo table 100
ip rule add fwmark 1 lookup 100
iptables -t mangle -A SHADOWSOCKS -p udp --dport 53 -j TPROXY --on-port 1080 --tproxy-mark 0x01/0x01
iptables -t mangle -A SHADOWSOCKS_MARK -p udp --dport 53 -j MARK --set-mark 1

# Apply the rules
iptables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS

# Don't need DNS forwarding currently
# iptables -t mangle -A PREROUTING -j SHADOWSOCKS
# iptables -t mangle -A OUTPUT -j SHADOWSOCKS_MARK

# Ban
iptables -A INPUT -i ppp0 -p tcp --dport 1080 -j DROP
iptables -A INPUT -i ppp0 -p udp --dport 1080 -j DROP
