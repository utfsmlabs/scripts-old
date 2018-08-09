#!/bin/sh -x
# My system IP/set ip address of server
SSH_SERVER_IP="10.6.41.39"
SSH_SERVER2_IP="10.6.40.2"
DNS_SERVER_IP="200.1.22.240"
WEB_PAGE_IP="54.235.208.106"
WEB_PAGE2_IP="10.6.41.119"

# 1. Delete all existing rules
iptables -F
iptables -X

# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# 2. Set default chain policies
iptables -P INPUT ACCEPT 
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# 3. Allow SSH
iptables -A OUTPUT -p tcp -d $SSH_SERVER_IP -s 0/0 --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -d $SSH_SERVER2_IP -s 0/0 --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT


# 4. Allow HTTP one page only
iptables -A OUTPUT -p tcp -d $WEB_PAGE_IP --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -d $WEB_PAGE_IP --dport 8888 -j ACCEPT
iptables -A OUTPUT -p tcp -d $WEB_PAGE_IP --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp -d $WEB_PAGE2_IP --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -d $WEB_PAGE2_IP --dport 8888 -j ACCEPT
iptables -A OUTPUT -p tcp -d $WEB_PAGE2_IP --dport 443 -j ACCEPT

# 5. Allow DNS Queries
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# 6. Drop ALL!!!
iptables -A OUTPUT -j DROP
