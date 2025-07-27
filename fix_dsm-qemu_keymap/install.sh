#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Fix qemu-system-x86_64"
  cp -vf /usr/bin/launcher.dat /tmpRoot/usr/local/bin/launcher.dat
  cp -vf /usr/bin/fix-qemu-layout.sh /tmpRoot/usr/local/bin/fix-qemu-layout.sh

  DEST="/tmpRoot/usr/lib/systemd/system/fix-qemu-layout.service"
  echo "[Unit]"                               >${DEST}
  echo "Description=Fix qemu layout"     >>${DEST}
  echo "After=multi-user.target"             >>${DEST}
  echo                                       >>${DEST}
  echo "[Service]"                           >>${DEST}
  echo "Type=oneshot"                        >>${DEST}
  echo "RemainAfterExit=true"                >>${DEST}
  echo "ExecStart=/usr/local/bin/fix-qemu-layout.sh"    >>${DEST}
  echo                                       >>${DEST}
  echo "[Install]"                           >>${DEST}
  echo "WantedBy=multi-user.target"          >>${DEST}

  mkdir -vp /tmpRoot/lib/systemd/system/multi-user.target.wants
  ln -vsf /usr/lib/systemd/system/fix-qemu-layout.service /tmpRoot/lib/systemd/system/multi-user.target.wants/fix-qemu-layout.service
fi



