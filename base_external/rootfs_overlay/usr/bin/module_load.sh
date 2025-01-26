#!/bin/sh

# Check for the correct number of arguments
if [ $# -ne 1 ]; then
    echo "Wrong number of arguments"
    echo "usage: $0 module_name"
    echo "Will create a corresponding device /dev/module_name associated with module_name.ko"
    exit 1
fi

module=$1
device=$1
mode="664"

# Determine the appropriate group
if grep -q '^staff:' /etc/group; then
    group="staff"
else
    group="wheel"
fi

# Load the module and exit on failure
if ! insmod /lib/modules/$(uname -r)/extra/$module.ko $*; then
    echo "Failed to load module $module"
    exit 1
fi

# Get the major number from /proc/devices
major=$(awk "\$2==\"$module\" {print \$1}" /proc/devices)

if [ -n "$major" ]; then
    # Remove any existing /dev node for the device
    rm -f /dev/${device}
    
    # Add a node for the device
    mknod /dev/${device} c $major 0
    
    # Change group owner and access mode
    chgrp $group /dev/${device}
    chmod $mode /dev/${device}
else
    echo "No device found in /proc/devices for driver ${module} (this driver may not allocate a device)"
fi