#!/bin/ash

rm -f /usr/local/bin/qemu-system-x86_64
cp -vf /usr/bin/launcher.dat /usr/local/bin/qemu-system-x86_64
cp -vf /usr/bin/fix-qemu-layout.sh /usr/local/bin/fix-qemu-layout.sh
chmod 755 /usr/local/bin/qemu-system-x86_64
chmod 755 /usr/local/bin/fix-qemu-layout.sh