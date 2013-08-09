#!/bin/bash
echo Setting firewall rules...
#
#



###### Debut Initialisation ######

# Interdire toutes connexions entrantes
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
echo - Interdire toute connexion entrante : [OK]

# Interdire toutes connexions sortantes
iptables -t filter -P OUTPUT DROP
echo - Interdire toute connexion sortante : [OK]

# Vider les tables actuelles
iptables -t filter -F
iptables -t filter -X
echo - Vidage : [OK]




# Anti Woot-Woot
iptables -I INPUT -d <IP_DU_SERVEUR> -p tcp --dport 80 -m string --to 70 \
 --algo bm --string 'GET /w00tw00t.at.ISC.SANS.' -j DROP
echo - Anti Woot-Woot : [OK]




#Gestion firewall SMTP
#Creation d'une chaine
iptables -N LOG_REJECT_SMTP
iptables -A LOG_REJECT_SMTP -j LOG --log-prefix ' SMTP REJECT PAQUET : '
iptables -A LOG_REJECT_SMTP -j DROP

# Anti-Taiwanais spam
iptables -t filter -A INPUT -i eth0 -s 61.64.128.0/17 -j LOG_REJECT_SMTP
iptables -t filter -A INPUT -i eth0 -s 122.120.0.0/13 -j LOG_REJECT_SMTP
iptables -t filter -A INPUT -i eth0 -s 168.95.0.0/16 -j LOG_REJECT_SMTP
echo - Bloquer Taiwanais : [OK]




# Anti scan
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
echo "- Anti scan : [OK]"




#Autorisation des ports principaux
# Ne pas casser les connexions etablies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
echo - Ne pas casser les connexions établies : [OK]

# Autoriser la Supervision du serveur (SNMP)
iptables -t filter -A INPUT -p tcp --dport 161 -s IP_SUPERVISION/32 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 161 -s IP_SUPERVISION/32 -j ACCEPT
echo - Autoriser Supervision : [OK]

# Autoriser les requetes DNS, FTP, HTTP, NTP
iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
echo - Autoriser les requetes DNS, FTP, HTTP : [OK]

# Autoriser loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT
echo - Autoriser loopback : [OK]

# Autoriser ping
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT
echo - Autoriser ping : [OK]







#Autorisation des serveur locaux
# HTTP
iptables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
echo - Autoriser serveur Nginx : [OK]# HTTP
echo - Autoriser serveur FTP : [OK]

iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#DNS
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
echo - Autoriser serveur Bind : [OK]

# Mail
iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
echo - Autoriser serveur Mail : [OK]



#Autoriser le partage SAMBA
iptables -A INPUT -p tcp --dport 139 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 139 -j ACCEPT

#Autoriser istats (Monitoring du serveur via IOS)
iptables -A INPUT -p tcp --dport 5109 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5109 -j ACCEPT
