#!/bin/sh
# shellcheck disable=SC1091
. ./init_functions.sh

# The internal storage (UFS) still holds the stock Android system and its
# firmware partitions. 60-ufs-readonly.rules marks its disks read-only when
# udev sees them. Make sure that this has happened before the other hooks and
# the search for the root partition look at the disks, and stop if it cannot
# be done.
for disk in /sys/block/sd*; do
	[ -e "$disk" ] || continue
	case "$(readlink -f "$disk")" in
		*/13520000.ufs/*) ;;
		*) continue ;;
	esac

	dev="/dev/${disk##*/}"
	if [ "$(cat "$disk/ro")" != "1" ]; then
		echo "WARNING: $dev was not read-only, setting it now"
		blockdev --setro "$dev"
	fi

	if [ "$(cat "$disk/ro")" != "1" ]; then
		echo "ERROR: unable to make $dev read-only, stopping."
		splash_set_error "Internal storage is not read-only ($dev)"
		fail_halt_boot
	fi
done
