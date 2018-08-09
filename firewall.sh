#!/bin/sh
# Init file for OpenSSH server daemon
#
# chkconfig: 2345 55 25
# description: OpenSSH server daemon
#
# processname: sshd
# config: /etc/ssh/ssh_host_key
# config: /etc/ssh/ssh_host_key.pub
# config: /etc/ssh/ssh_random_seed
# config: /etc/ssh/sshd_config
# pidfile: /var/run/sshd.pid
SERVER_IP="159.203.191.168"
# eliminar reglas anteriores
iptables -F
iptables -X
# Aceptar todo por defecto
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
# permitir trafico local
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
# permitir trafico ssh desde cualquier parte
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 0/0 -d 0/0 --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
# permitir trafico dhcp
iptables -A INPUT -p udp -m multiport --sport 53,67 -m state --state ESTABLISHED,RELATED -j ACCEPT
# permitir acceso a la pagina
iptables -A INPUT -p tcp -m multiport --sport 80 -s $SERVER_IP -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -d $SERVER_IP -j ACCEPT
# bloquear el resto
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
