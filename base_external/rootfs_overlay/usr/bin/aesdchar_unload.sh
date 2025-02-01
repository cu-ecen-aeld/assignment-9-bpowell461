#!/bin/sh
module=$1
device=$1
cd `dirname $0`
# invoke rmmod with all arguments we got
rmmod $module || exit 1
# Remove stale nodes
rm -f /dev/${device}