#!/bin/sh
SERVER_IP="92.222.246.128 52.55.199.192 212.193.33.27 129.62.151.3"
# eliminar reglas anteriores
iptables -F
iptables -X
# accept todo por defecto
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
# permitir trafico local
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
# permitir trafico ssh desde cualquier parte
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 0/0 -d 0/0 --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
# permitir trafico dhcp
iptables -A INPUT -p udp -m multiport --sport 53,67 -m state --state ESTABLISHED,RELATED -j ACCEPT
# permitir acceso a la pagina
for i in $( echo $SERVER_IP)
do
	iptables -A INPUT -p tcp -m multiport --sport 80 -d $i -m state --state ESTABLISHED,RELATED -j ACCEPT
done
# bloquear el resto
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
