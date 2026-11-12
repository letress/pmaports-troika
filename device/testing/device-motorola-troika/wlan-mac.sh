#!/bin/sh
# The bootloader passes the factory WLAN address on the kernel command line
# (androidboot.wifimacaddr=<address>[,<second address>]). Hand the first one
# to the SCSC driver, which reads it when the interface is brought up;
# without it the driver picks a random address.

param=/sys/module/scsc_wlan/parameters/mac_addr

for word in $(cat /proc/cmdline); do
	case "$word" in
	androidboot.wifimacaddr=*)
		addr="${word#*=}"
		addr="${addr%%,*}"
		;;
	esac
done

case "$addr" in
[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f])
	# No newline: the parameter holds exactly one address
	[ -w "$param" ] && printf '%s' "$addr" > "$param"
	;;
esac
