#!/bin/bash

function run_iscsi {

for i in $(cat /proc/cmdline); do
	case $i in
		iscsi-host*) ISCSI_HOST=$(echo $i | cut -f2 -d"=") ;;
		iscsi-initiator*) ISCSI_INITIATOR=$(echo $i | cut -f2 -d"=") ;;
		iscsi-target*) ISCSI_TARGET=$(echo $i | cut -f2 -d"=") ;;
		iscsi-if*) ISCSI_IF=$(echo $i | cut -f2 -d"=") ;;
	esac
done

net_device=$(cat /proc/net/dev | grep "$ISCSI_IF")

while [ "$net_device" = "" ]; do
	echo "wating for nic card to be initialised"

	sleep 5
	
	net_device=$(cat /proc/net/dev | grep "$ISCSI_IF")

done

if [ "$ISCSI_HOST" != "" ] && [ "$ISCSI_INITIATOR" != "" ] && [ "$ISCSI_TARGET" != "" ]; then

echo "Bringing up $ISCSI_IF for iSCSI..."

ifconfig eth0 0.0.0.0
/sbin/udhcpc --now
sleep 4
ifconfig

echo "Connecting to iSCSI target $ISCSI_TARGET on $ISCSI_HOST..."

iscsistart -i $ISCSI_INITIATOR -t $ISCSI_TARGET -g 1 -a $ISCSI_HOST

sleep 2
fi

}

for i in $(cat /proc/cmdline); do
        case $i in
                atv-boot=iscsi)  run_aoe ;;
        esac
done

