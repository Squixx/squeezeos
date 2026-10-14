#!/bin/sh

# exit if this script is already running in the background

if pidof -o %PPID $(basename $0) >/dev/null; then
        echo "Process already running"
        exit 0
fi

trap "" HUP INT QUIT TSTP

while true; do
# at startup, wait until system is settled
 sleep 300

 GATEWAY_FAILS=0
 while true; do
#wake up every 5 seconds to check arp table
  sleep 5

#only do this if eth0 state is down (not connected to RJ45)
  ETH0_UP_COUNT=`ip link | grep eth0 | grep "state UP" | wc -l`
  if [ $ETH0_UP_COUNT -eq 0 ]; then
    ARP_TABLE_COUNT=`cat /proc/net/arp | wc -l`
    echo -n . 

#a wedged driver often keeps stale ARP entries, so also check that the
#default gateway still answers ARP; restart after 3 failed checks in a row
    GATEWAY=`ip route | sed -n 's/^default via \([0-9.]*\) dev eth1.*/\1/p'`
    if [ -n "$GATEWAY" ] && arping -q -I eth1 -c 2 -w 4 $GATEWAY >/dev/null 2>&1; then
      GATEWAY_FAILS=0
    else
      GATEWAY_FAILS=$((GATEWAY_FAILS + 1))
    fi

#ARP_TABLE_COUNT includes 1 line of header, ignore that
    if [ $ARP_TABLE_COUNT -le 1 ] || [ $GATEWAY_FAILS -ge 3 ]; then      
	echo "restarting wifi"
	logger "*** restarting wifi, ARP_TABLE_COUNT = $ARP_TABLE_COUNT, GATEWAY_FAILS = $GATEWAY_FAILS"
	GATEWAY_FAILS=0

	# restart wifi driver
	/etc/init.d/wlan stop && /etc/init.d/wlan start
	# stop dhcp
	killall udhcpc 
	# make sure we reconnect to AP
	wpa_cli reassociate
	# restart dhcp
	udhcpc -R -a -p/var/run/udhcpc.eth1.pid -b --syslog -ieth1 -H `hostname` -s /etc/network/udhcpc_action
	
	# won't restart wifi more than once every 5 minutes
	sleep 300
    fi
  fi
 done
done 2>&1 > /dev/null < /dev/null &
