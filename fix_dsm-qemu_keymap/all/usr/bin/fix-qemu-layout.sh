#!/bin/ash
cd /usr/local/bin/
mv -f qemu-system-x86_64 qemu-system-x86_64.backup
cp -vf launcher.dat qemu-system-x86_64
chmod 755 qemu-system-x86_64
