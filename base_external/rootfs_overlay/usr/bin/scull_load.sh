#!/bin/sh
# $Id: scull_load,v 1.4 2004/11/03 06:19:49 rubini Exp $
module="scull"
device="scull"
mode="664"

# Group: since distributions do it differently, look for wheel or use staff
if grep -q '^staff:' /etc/group; then
    group="staff"
else
    group="wheel"
fi

# invoke insmod with all arguments we got
# and use a pathname, as insmod doesn't look in . by default
insmod /lib/modules/$(uname -r)/extra/$module.ko $* || exit 1

# retrieve major number
major=$(awk "\$2==\"$module\" {print \$1}" /proc/devices)

# Function to create device nodes
create_device_node() {
    local name=$1
    local major=$2
    local minor=$3
    rm -f /dev/${name}
    mknod /dev/${name} c $major $minor
    chgrp $group /dev/${name}
    chmod $mode /dev/${name}
}

# Create scull device nodes
for i in 0 1 2 3; do
    create_device_node "${device}${i}" $major $i
done
ln -sf ${device}0 /dev/${device}

# Create scullpipe device nodes
for i in 0 1 2 3; do
    create_device_node "${device}pipe${i}" $major $((i + 4))
done
ln -sf ${device}pipe0 /dev/${device}pipe

# Create other scull device nodes
create_device_node "${device}single" $major 8
create_device_node "${device}uid" $major 9
create_device_node "${device}wuid" $major 10
create_device_node "${device}priv" $major 11
