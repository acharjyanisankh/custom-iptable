#!/bin/bash
echo "Before Running this script please update sysctl.conf"
echo "and set the things properly : Thanks"
INT_IF="eth1" # connected to internet
SERVER_IP="202.54.10.20" # server IP
LAN_RANGE="192.168.1.0/24" # your LAN IP range
 
# Add your spoofed IP range/IPs here
SPOOF_IPS="0.0.0.0/8 127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 224.0.0.0/3"
 
IPT="/sbin/iptables" # path to iptables
 
# default action, can be DROP or REJECT
ACTION="DROP"
 
# Drop packet that claiming from our own server on WAN port
$IPT -A INPUT -i $INT_IF -s $SERVER_IP -j $ACTION
$IPT -A OUTPUT -o $INT_IF -s $SERVER_IP -j $ACTION
 
# Drop packet that claiming from our own internal LAN on WAN port
$IPT -A INPUT -i $INT_IF -s $LAN_RANGE -j $ACTION
$IPT -A OUTPUT -o $INT_IF -s $LAN_RANGE -j $ACTION
 
## Drop all spoofed
for ip in $SPOOF_IPS
do
	 $IPT -A INPUT -i $INT_IF -s $ip -j $ACTION
	  $IPT -A OUTPUT -o $INT_IF -s $ip -j $ACTION
  done
  ## add or call your rest of script below to customize iptables ##
