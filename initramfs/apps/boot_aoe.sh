#!/bin/bash


function run_aoe {
AOE_IF=eth0

/sbin/aoe-mkdevs /dev/etherd

for i in $(cat /proc/cmdline); do
        case $i in
                aoe-if*) AOE_IF=$(echo $i | cut -f2 -d"=") ;;
        esac
done


net_device=$(cat /proc/net/dev | grep "$AOE_IF")

while [ "$net_device" = "" ]; do
	echo "wating for nic card to be initialised"

	sleep 5
	
	net_device=$(cat /proc/net/dev | grep "$ISCSI_IF")

done


echo "Bringing up $AOE_IF for AOE..."

ifconfig eth0 0.0.0.0
/sbin/udhcpc --now
sleep 4
ifconfig

echo "Discovering aoe disks on $AOE_IF..."

/sbin/aoe-interfaces $AOE_IF 


/sbin/aoe-discover

sleep 5

/sbin/aoe-stat

}

for i in $(cat /proc/cmdline); do
        case $i in
                atv-boot=aoe)  run_aoe ;;
        esac
done

