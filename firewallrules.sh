#!/bin/bash
echo Setting firewall rules for OpenShift...
#
#

###### Debut Initialisation ######

#Autorisation des ports principaux
# Ne pas casser les connexions etablies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
echo - Ne pas casser les connexions etablies : [OK]

# Interdire toute connexion entrante
iptables -P INPUT DROP
iptables -P FORWARD DROP
#echo - Interdire toute connexion entrante : [OK]

# Interdire toute connexion sortante
iptables -P OUTPUT DROP
#echo - Interdire toute connexion sortante : [OK]

# Gestion des ouvertures OpenShift chaine sortante
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT     #SSH
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT     #HTTP
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT    #HTTPS
iptables -A OUTPUT -p tcp --dport 8000 -j ACCEPT   
iptables -A OUTPUT -p tcp --dport 8443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 61613 -j ACCEPT   #Activemq
iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT      
iptables -A OUTPUT -p tcp --dport 27017 -j ACCEPT   #MongoDB
iptables -A OUTPUT -p tcp --dport 8161 -j ACCEPT    #Activemq (WebConsole)
iptables -A OUTPUT -p tcp --dport 8080 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8118 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 59196 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT      #DNS TCP
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT      #DNS UDP
iptables -I OUTPUT 4 -m tcp -p tcp --dport 35531:65535 -m state --state NEW -j ACCEPT  #Plage de port dynamique OpenShift
iptables -I OUTPUT 1 -j rhc-app-comm
iptables -A OUTPUT -p icmp -j ACCEPT                #Requete ICMP (ping)
iptables -A OUTPUT -p tcp --dport 5435 -j ACCEPT
echo - Autorisation des connexions sortantes sur les ports necessaires a OpenShift: [OK]

# Gestion des ouvertures OpenShift chaine entrante
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8443 -j ACCEPT
iptables -A INPUT -p tcp --dport 61613 -j ACCEPT   #Activemq
iptables -A INPUT -p tcp --dport 25 -j ACCEPT      
iptables -A INPUT -p tcp --dport 27017 -j ACCEPT   #MongoDB
iptables -A INPUT -p tcp --dport 8161 -j ACCEPT    #Activemq (WebConsole)
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 8118 -j ACCEPT
iptables -A INPUT -p tcp --dport 59196 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT      #DNS TCP
iptables -A INPUT -p udp --dport 53 -j ACCEPT      #DNS UDP
iptables -I INPUT 4 -m tcp -p tcp --dport 35531:65535 -m state --state NEW -j ACCEPT   #Plage de port dynamique OpenShift
iptables -I INPUT 5 -j rhc-app-comm
iptables -A INPUT -p icmp -j ACCEPT                #Requete ICMP (ping)
iptables -A INPUT -p tcp --dport 5435 -j ACCEPT
echo - Autorisation des connexions entrantes sur les ports necessaires a OpenShift: [OK]
