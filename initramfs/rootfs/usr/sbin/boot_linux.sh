#!/bin/bash
#
# kexec auto-boot
# search for grub, kboot, syslinux, isolinux or mb_boot_tv boot confgs
# kexec boot the first one you find.
#
#
#
#
# ROOT is where the rootfs partition is mounted
ROOT=/mnt/rootfs
if [ ! -d "$ROOT" ]; then
	mkdir $ROOT
fi

# sda is typically the appletv internal hard drive (there can be only one)
# sdb is typically a USB disk device (pen or HD)
#
#SEARCH1="`ls /dev/sd* | grep sd[b-h][1-9]`"
#SEARCH2=" `ls /dev/sda* | grep sd[a][1-9]`"
case "$1" in 
     aoe)
       SEARCH1="`grep etherd/e[0-1000].[0-1000]p[1-9] /proc/partitions | awk '{print $4}'` "
     ;;
     *)
       SEARCH1="`grep sd[b-h][1-9] /proc/partitions | awk '{print $4}'`"
       SEARCH2=" `grep sd[a][1-9] /proc/partitions | awk '{print $4}'`"
     ;;
esac

SEARCH_PARTITIONS="$SEARCH1""$SEARCH2"
#echo $SEARCH_PARTITIONS

# search for boot configs
for x in $SEARCH_PARTITIONS; do
	if `mount -o ro,noatime /dev/${x} $ROOT > /dev/null 2>&1`; then
		BOOT_CONFIG=""
                if [ -f "$ROOT/mb_boot_tv.conf" ]; then
                        echo "${x}/mb_boot_tv.conf found"
                        BOOT_CONFIG=$ROOT/mb_boot_tv.conf
                        #
                elif [ -f "$ROOT/boot/mb_boot_tv.conf" ]; then
                        echo "${x}/boot/mb_boot_tv.conf found"
                        BOOT_CONFIG=$ROOT/boot/mb_boot_tv.conf
                        #

		elif [ -f "$ROOT/boot/grub/menu.lst" ]; then
			echo "${x}/boot/grub menu.lst found"
			BOOT_CONFIG=$ROOT/boot/grub/menu.lst
			#
		elif [ -f "$ROOT/grub/menu.lst" ]; then
			echo "${x}/grub menu.lst found"
			BOOT_CONFIG=$ROOT/grub/menu.lst
			#

		elif [ -f "$ROOT/syslinux.cfg" ]; then
			echo "${x}/syslinux.cfg found"
			BOOT_CONFIG=$ROOT/syslinux.cfg
			#
                elif [ -f "$ROOT/isolinux.cfg" ]; then
                        echo "${x}/isolinux.cfg found"
                        BOOT_CONFIG=$ROOT/isolinux.cfg
                        #
		elif [ -f "$ROOT/isolinux/isolinux.cfg" ]; then
			echo "${x}/isolinux/isolinux.cfg found"
			BOOT_CONFIG=$ROOT/isolinux/isolinux.cfg
			#

		elif [ -f "$ROOT/kboot.conf" ]; then
			echo "${x}/kboot.conf found"
			BOOT_CONFIG=$ROOT/kboot.conf
			#
		fi

		if [ "$BOOT_CONFIG" != "" ]; then
			# a bit odd way to do this because of the quoted
			# --command-line params and I'm new to bash
			echo "#!/bin/bash" > /tmp/kexec_load.sh
			boot_parser --root="$ROOT" --config="$BOOT_CONFIG" >> /tmp/kexec_load.sh
			for i in $(cat /proc/cmdline); do
    		        	case $i in
                			aoe-if*)  extra_cmd="$extra_cmd $i";;
                			iscsi-host*) extra_cmd="$extra_cmd $i";;
					iscsi-initiator*) extra_cmd="$extra_cmd $i";;
					iscsi-target*) extra_cmd="$extra_cmd $i";;
					iscsi-if*) extra_cmd="$extra_cmd $i";;
					atv-boot*)  extra_cmd="$extra_cmd $i";;
		        	esac
			done
			kexec1=`grep command-line /tmp/kexec_load.sh | awk -F"--command-line=" '{print $1}' `
			kexec2=`grep command-line /tmp/kexec_load.sh | awk -F"--command-line=" '{print $2}' | sed -e "s/\"//g"`
			kexec2="$kexec2 $extra_cmd"
			echo "#!/bin/bash" > /tmp/kexec_load.sh
			echo $kexec1 --append=\"$kexec2\" >> /tmp/kexec_load.sh
			chmod +x /tmp/kexec_load.sh
			cat /tmp/kexec_load.sh
	    		if /tmp/kexec_load.sh; then
				echo "kexec jump to new kernel"
				# umount all filesystem
				cd /
				umount -a
				kexec -e
				# if we get here, kexec failed
				umount $ROOT
				# mount everything again
				mount -a
				exit 1
			fi
		fi
		#
		umount $ROOT
	fi
done

exit 0
