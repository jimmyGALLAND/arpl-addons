#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Starting eudev daemon"
  if [ "6" = "$(/bin/get_key_value /etc.defaults/VERSION majorversion)" ]; then
    mv /lib/libblkid.so.1 /lib/libblkid.so.1.v7bak
    mv /lib/libblkid.so.1.v6bak /lib/libblkid.so.1
  fi
  [ -e /proc/sys/kernel/hotplug ] && printf '\000\000\000\000' > /proc/sys/kernel/hotplug
  chmod 755 /sbin/udevd /bin/kmod /bin/udevadm /lib/udev/*
  /sbin/udevd -d || { echo "FAIL"; exit 1; }
  echo "Triggering add events to udev"
  udevadm trigger --type=subsystems --action=add
  udevadm trigger --type=devices --action=add
  udevadm trigger --type=devices --action=change
  udevadm settle --timeout=30 || echo "udevadm settle failed"
  # Give more time
  sleep 10
  # Remove from memory to not conflict with RAID mount scripts
  /usr/bin/killall udevd
elif [ "${1}" = "late" ]; then
  # Copy rules
  cp -vf /etc/udev/rules.d/* /tmpRoot/usr/lib/udev/rules.d/
  DEST="/tmpRoot/lib/systemd/system/udevrules.service"

  echo "[Unit]"                                                                  >${DEST}
  echo "Description=Reload udev rules"                                          >>${DEST}
  echo                                                                          >>${DEST}
  echo "[Service]"                                                              >>${DEST}
  echo "Type=oneshot"                                                           >>${DEST}
  echo "RemainAfterExit=true"                                                   >>${DEST}
  echo "ExecStart=/usr/bin/udevadm hwdb --update"                               >>${DEST}
  echo "ExecStart=/usr/bin/udevadm control --reload-rules"                      >>${DEST}
  echo                                                                          >>${DEST}
  echo "[Install]"                                                              >>${DEST}
  echo "WantedBy=multi-user.target"                                             >>${DEST}

  mkdir -vp /tmpRoot/lib/systemd/system/multi-user.target.wants
  ln -vsf /lib/systemd/system/udevrules.service /tmpRoot/lib/systemd/system/multi-user.target.wants/udevrules.service
fi
