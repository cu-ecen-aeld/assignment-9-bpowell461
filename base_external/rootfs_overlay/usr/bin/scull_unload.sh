#!/bin/sh

module="scull"
device="scull"

# Invoke rmmod with all arguments we got
rmmod $module "$@" || exit 1

# Remove stale nodes
for suffix in "" "[0-3]" "priv" "pipe" "pipe[0-3]" "single" "uid" "wuid"; do
    rm -f /dev/${device}${suffix}
done