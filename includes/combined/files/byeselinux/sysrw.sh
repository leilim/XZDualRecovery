#!/data/local/tmp/recovery/busybox sh
######
#
# Part of byeselinux, created originally by zxz0O0, modified for use in XZDualRecovery by [NUT]
#

BUSYBOX="/data/local/tmp/recovery/busybox"

$BUSYBOX mount -o remount,rw /system 2> /dev/null
if [ "$?" = "0" ]; then
	echo "No system mount security"
	exit 0
fi

if [ ! -f /data/local/tmp/recovery/wp_mod.ko ]; then
	echo "Error patching kernel module. File not found."
	exit 1
fi

if [ ! -f /data/local/tmp/recovery/modulecrcpatch ]; then
	echo "Error: modulecrcpatch not found"
	exit 1
fi

if [ "$($BUSYBOX grep '/sys/kernel/security/sony_ric/enable' /init.* | $BUSYBOX wc -l)" != "0" ]; then

	$BUSYBOX chmod 777 /data/local/tmp/recovery/modulecrcpatch
	for module in /system/lib/modules/*.ko; do
	        /data/local/tmp/recovery/modulecrcpatch $module /data/local/tmp/recovery/wp_mod.ko 1> /dev/null
	done

	$BUSYBOX insmod /data/local/tmp/recovery/wp_mod.ko

fi

$BUSYBOX mount -o remount,rw /system 2> /dev/null
if [ "$?" != "0" ]; then
	echo "Remount R/W failed!"
	exit 1
fi

$BUSYBOX cp /data/local/tmp/recovery/wp_mod.ko /system/lib/modules/wp_mod.ko
$BUSYBOX chmod 644 /system/lib/modules/wp_mod.ko

echo "Module installed succesfully."

exit 0
