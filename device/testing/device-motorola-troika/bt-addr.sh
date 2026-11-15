#!/bin/sh
# The bootloader passes the factory Bluetooth address on the kernel command
# line (androidboot.btmacaddr=<address>). The SCSC Bluetooth driver reads it
# from the file motorola/troika/bt_addr in the firmware directory when it
# starts, so write it there before the driver is loaded (see bluetooth.conf);
# without it the radio uses an address of its own.

dir=/usr/lib/firmware/motorola/troika

for word in $(cat /proc/cmdline); do
	case "$word" in
	androidboot.btmacaddr=*)
		addr="${word#*=}"
		;;
	esac
done

case "$addr" in
[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f])
	mkdir -p "$dir" && printf '%s\n' "$addr" > "$dir/bt_addr"
	;;
esac
