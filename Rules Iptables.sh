#!/bin/bash
echo Setting firewall rules...
#
#



###### Start Initialization ######

# Prohibit all incoming connections
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
echo - Prohibit all incoming connections : [OK]

# Prohibit all outgoing connections
iptables -t filter -P OUTPUT DROP
echo -  Prohibit all outgoing connections : [OK]

# Empty tables present
iptables -t filter -F
iptables -t filter -X
echo - Empty tables : [OK]




# Anti Woot-Woot
iptables -I INPUT -d <IP_DU_SERVEUR> -p tcp --dport 80 -m string --to 70 \
 --algo bm --string 'GET /w00tw00t.at.ISC.SANS.' -j DROP
echo - Anti Woot-Woot : [OK]




# Management SMTP firewall
# Creation of a string
iptables -N LOG_REJECT_SMTP
iptables -A LOG_REJECT_SMTP -j LOG --log-prefix ' SMTP REJECT PAQUET : '
iptables -A LOG_REJECT_SMTP -j DROP

# Anti-Taiwanais spam
iptables -t filter -A INPUT -i eth0 -s 61.64.128.0/17 -j LOG_REJECT_SMTP
iptables -t filter -A INPUT -i eth0 -s 122.120.0.0/13 -j LOG_REJECT_SMTP
iptables -t filter -A INPUT -i eth0 -s 168.95.0.0/16 -j LOG_REJECT_SMTP
echo - Anti Taiwanais : [OK]




# Anti scan
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
echo - Anti scan : [OK]




# Properties major ports
# Do not break established connections
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "- Do not break established connections : [OK]"

# Allow Monitoring Server (SNMP)
iptables -t filter -A INPUT -p tcp --dport 161 -s IP_SUPERVISION/32 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 161 -s IP_SUPERVISION/32 -j ACCEPT
echo - Allow Monitoring Server (SNMP) : [OK]

# Allow DNS queries, FTP, HTTP, NTP
iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
echo - Allow DNS queries, FTP, HTTP, NTP : [OK]

# Allow loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT
echo - Allow loopback : [OK]

# Allow ping
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT
echo - Allow ping : [OK]







# Local server properties
# HTTP
iptables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
echo - Local server properties: [OK]

iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#DNS
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
echo - Allow Server Bind : [OK]

# Mail
iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
echo - Allow Server Mail : [OK]



# Allow sharing SAMBA
iptables -A INPUT -p tcp --dport 139 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 139 -j ACCEPT

# Allow iStats (Monitoring Server via IOS)
iptables -A INPUT -p tcp --dport 5109 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5109 -j ACCEPT
