#!/usr/bin/env ash

#if [ "${1}" = "early" ]; then
  #/usr/sbin/acpid
#el
if [ "${1}" = "late" ]; then
  #/usr/bin/killall acpid
  echo "Installing daemon for ACPI button"
  cp -v /usr/sbin/acpid /tmpRoot/usr/sbin/acpid
  mkdir -p /tmpRoot/etc/acpi/events/
  cp -v /etc/acpi/events/power /tmpRoot/etc/acpi/events/power
  cp -v /etc/acpi/power.sh /tmpRoot/etc/acpi/power.sh
  cp -v /etc/init/acpid.conf /tmpRoot/etc/init/acpid.conf
fi
