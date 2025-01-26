#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Wrong number of arguments"
    echo "usage: $0 module_name"
    echo "Will unload the module specified by module_name and remove associated device"
    exit 1
fi

module=$1
device=$1

# Unload the module
if ! rmmod "$module"; then
    exit 1
fi

# Remove stale device nodes
rm -f "/dev/${device}"