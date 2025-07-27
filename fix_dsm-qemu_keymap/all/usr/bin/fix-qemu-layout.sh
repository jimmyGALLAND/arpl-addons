#!/bin/ash

if [ ! -f /var/packages/Virtualization/target/bin/qemu-system-x86_64.bin ]; then

	mv -f /var/packages/Virtualization/target/bin/qemu-system-x86_64  /var/packages/Virtualization/target/bin/qemu-system-x86_64.bin
	mv -f /usr/bin/launcher  /var/packages/Virtualization/target/bin/qemu-system-x86_64
	chmod ug+x /var/packages/Virtualization/target/bin/qemu-system-x86_64

fi
