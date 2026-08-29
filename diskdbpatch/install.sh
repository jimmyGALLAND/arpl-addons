#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Creating service to exec DiskDBPatch"
  cp -vf /usr/sbin/diskdbpatch.sh /tmpRoot/usr/sbin/diskdbpatch.sh
  cp -vf /usr/sbin/syno_hdd_vendor_ids.txt/tmpRoot/usr/sbin/syno_hdd_vendor_ids.txt

  DEST="/tmpRoot/lib/systemd/system/diskdbpatch.service"
  echo "[Unit]"                                                                >${DEST}
  echo "Description=Enable DiskDBPatch"                                       >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Service]"                                                            >>${DEST}
  echo "Type=oneshot"                                                         >>${DEST}
  echo "RemainAfterExit=true"                                                 >>${DEST}
  echo "ExecStart=/usr/sbin/diskdbpatch.sh -nfre"                             >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Install]"                                                            >>${DEST}
  echo "WantedBy=multi-user.target"                                           >>${DEST}

  mkdir -vp /tmpRoot/lib/systemd/system/multi-user.target.wants
  ln -vsf /lib/systemd/system/diskdbpatch.service /tmpRoot/lib/systemd/system/multi-user.target.wants/diskdbpatch.service
fi
