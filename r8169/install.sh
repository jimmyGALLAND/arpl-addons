#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for Realtek R8169 Ethernet adapter"
  ${INSMOD} "/modules/mii.ko"
  ${INSMOD} "/modules/r8169.ko" ${PARAMS}
fi
